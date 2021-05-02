//  Created by Geoff Pado on 4/15/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

open class BasePhotoEditingViewController: UIViewController, UIScrollViewDelegate, UIColorPickerViewControllerDelegate {
    public init(asset: PHAsset? = nil, image: UIImage? = nil, redactions: [Redaction]? = nil, completionHandler: ((UIImage) -> Void)? = nil) {
        self.asset = asset
        self.image = image
        self.completionHandler = completionHandler
        super.init(nibName: nil, bundle: nil)

        photoEditingView.add(redactions ?? [])
        updateToolbarItems(animated: false)

        redactionChangeObserver = NotificationCenter.default.addObserver(forName: PhotoEditingRedactionView.redactionsDidChange, object: nil, queue: .main, using: { [weak self] _ in
            self?.updateToolbarItems()
        })

        #if targetEnvironment(macCatalyst)
        ColorPanel.shared.color = .black
        colorObserver = NotificationCenter.default.addObserver(forName: ColorPanel.colorDidChangeNotification, object: nil, queue: .main, using: { [weak self] notification in
            guard let colorPanel = notification.object as? ColorPanel else { return }
            self?.photoEditingView.color = colorPanel.color
        })
        #endif
    }

    open override func loadView() {
        view = photoEditingView
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let options = PHImageRequestOptions()
        options.version = .current
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true

        if image != nil {
            updateScrollView()
        } else if let asset = asset {
            imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: options) { [weak self] image, info in
                let isDegraded = (info?[PHImageResultIsDegradedKey] as? NSNumber)?.boolValue ?? false
                guard let image = image, isDegraded == false else { return }

                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }

    // MARK: Edit Protection

    @objc open func markHasMadeEdits() {} // hook for responder chain

    // MARK: Sharing

    public func exportImage(completionHandler: @escaping ((UIImage?) -> Void)) {
        guard let image = photoEditingView.image else { return completionHandler(nil) }
        PhotoExporter.export(image, redactions: photoEditingView.redactions) { result in
            switch result {
            case .success(let image): completionHandler(image)
            case .failure: completionHandler(nil)
            }
        }
    }

    // MARK: Highlighters

    public var highlighterTool: HighlighterTool { return photoEditingView.highlighterTool }

    @objc func toggleHighlighterTool() {
        let currentTool = photoEditingView.highlighterTool
        let allTools = HighlighterTool.allCases
        let currentToolIndex = allTools.firstIndex(of: currentTool) ?? allTools.startIndex
        let nextToolIndex = (currentToolIndex + 1) % allTools.count
        let nextTool = allTools[nextToolIndex]
        photoEditingView.highlighterTool = nextTool
        updateToolbarItems()
    }

    @objc public func selectMagicHighlighter() {
        photoEditingView.highlighterTool = .magic
        updateToolbarItems()
    }

    @objc public func selectManualHighlighter() {
        photoEditingView.highlighterTool = .manual
        updateToolbarItems()
    }

    @objc public func selectEraser() {
        photoEditingView.highlighterTool = .eraser
        updateToolbarItems()
    }

    private func updateToolbarItems(animated: Bool = true) {
        let undoToolItem = UIBarButtonItem(image: Icons.undo, style: .plain, target: self, action: #selector(BasePhotoEditingViewController.undo))
        undoToolItem.isEnabled = undoManager?.canUndo ?? false

        let redoToolItem = UIBarButtonItem(image: Icons.redo, style: .plain, target: self, action: #selector(BasePhotoEditingViewController.redo))
        redoToolItem.isEnabled = undoManager?.canRedo ?? false

        let spacerItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let highlighterToolItem: UIBarButtonItem
        if #available(iOS 14, *) {
            highlighterToolItem = HighlighterToolBarButtonItem(tool: photoEditingView.highlighterTool, target: self)
        } else {
            let highlighterToolIcon = photoEditingView.highlighterTool.image
            highlighterToolItem = UIBarButtonItem(image: highlighterToolIcon, style: .plain, target: self, action: #selector(toggleHighlighterTool))
        }

        if #available(iOS 14.0, *) {
            let colorPickerToolItem = UIBarButtonItem(image: UIImage(systemName: "paintpalette"), style: .plain, target: self, action: #selector(showColorPicker))
            setToolbarItems([undoToolItem, redoToolItem, spacerItem, colorPickerToolItem, highlighterToolItem], animated: animated)
        } else {
            setToolbarItems([undoToolItem, redoToolItem, spacerItem, highlighterToolItem], animated: animated)
        }

        userActivity?.needsSave = true
    }

    // MARK: Color Picker

    @available(iOS 14.0, *)
    @objc public func showColorPicker(_ sender: Any) {
        if traitCollection.userInterfaceIdiom == .mac {
            ColorPanel.shared.makeKeyAndOrderFront(sender)
        } else if let toolbarItem = toolbarItems?.first(where: { $0.action == #selector(showColorPicker(_:)) }) {
            let picker = ColorPickerViewController()
            picker.delegate = self
            picker.popoverPresentationController?.barButtonItem = toolbarItem
            present(picker, animated: true, completion: nil)
        }
    }

    @available(iOS 14.0, *)
    public func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        photoEditingView.color = viewController.selectedColor
    }

    // MARK: Undo/Redo

    @objc private func undo(_ sender: Any) {
        undoManager?.undo()
        updateToolbarItems()
    }

    @objc private func redo(_ sender: Any) {
        undoManager?.redo()
        updateToolbarItems()
    }

    // MARK: Key Commands

    #if targetEnvironment(macCatalyst)
    #else
    private let undoKeyCommand = UIKeyCommand(action: #selector(BasePhotoEditingViewController.undo), input: "z", modifierFlags: .command, discoverabilityTitle: BasePhotoEditingViewController.undoKeyCommandDiscoverabilityTitle)
    private let redoKeyCommand = UIKeyCommand(action: #selector(BasePhotoEditingViewController.redo), input: "z", modifierFlags: [.command, .shift], discoverabilityTitle: BasePhotoEditingViewController.redoKeyCommandDiscoverabilityTitle)
    
    open override var keyCommands: [UIKeyCommand]? {
        return [undoKeyCommand, redoKeyCommand]
    }
    #endif
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(undo(_:)) {
            return undoManager?.canUndo ?? false
        } else if action == #selector(redo(_:)) {
            return undoManager?.canRedo ?? false
        }

        return super.canPerformAction(action, withSender: sender)
    }

    // MARK: Image

    public func load(_ image: UIImage) {
        guard self.image == nil else { return }
        self.image = image
    }

    private(set) public var image: UIImage? {
        didSet {
            updateScrollView()
        }
    }

    private func updateScrollView() {
        photoEditingView.image = image

        guard let image = image else { return }
        textRectangleDetector.detectTextRectangles(in: image) { [weak self] textObservations in
            DispatchQueue.main.async { [weak self] in
                self?.photoEditingView.textObservations = textObservations
            }
        }

        if #available(iOS 13.0, *) {
            textRectangleDetector.detectWords(in: image) { [weak self] recognizedTextObservations in
                guard let observations = recognizedTextObservations else { return }
                let matchingObservations = observations.filter { observation in
                    Defaults.autoRedactionsWordList.contains(where: { wordListString in
                        wordListString.compare(observation.string, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
                    })
                }

                DispatchQueue.main.async {
                    self?.photoEditingView.redact(matchingObservations)
                    self?.photoEditingView.wordObservations = observations
                }
            }
        }
    }

    // MARK: User Activity

    open override func updateUserActivityState(_ activity: NSUserActivity) {
        guard let editingActivity = (activity as? EditingUserActivity) else { return }
        if let asset = asset {
            editingActivity.assetLocalIdentifier = asset.localIdentifier
        } else if let image = image {
            imageCache.writeImageToCache(image, fileName: fileNameProvider?.representedFileName) { result in
                guard let url = try? result.get() else { return }
                editingActivity.imageBookmarkData = try? url.bookmarkData()
            }
        }
        editingActivity.redactions = photoEditingView.redactions
    }

    // MARK: Boilerplate

    public let completionHandler: ((UIImage) -> Void)?
    public var redactions: [Redaction] { return photoEditingView.redactions }

    private static let undoKeyCommandDiscoverabilityTitle = NSLocalizedString("BasePhotoEditingViewController.undoKeyCommandDiscoverabilityTitle", comment: "Discovery title for the undo key command")
    private static let redoKeyCommandDiscoverabilityTitle = NSLocalizedString("BasePhotoEditingViewController.redoKeyCommandDiscoverabilityTitle", comment: "Discovery title for the redo key command")

    private let asset: PHAsset?
    private var colorObserver: Any?
    private let imageCache = RestorationImageCache()
    private let imageManager = PHImageManager()
    private let textRectangleDetector = TextRectangleDetector()
    private let photoEditingView = PhotoEditingView()
    private var redactionChangeObserver: Any?

    deinit {
        colorObserver.map(NotificationCenter.default.removeObserver)
        redactionChangeObserver.map(NotificationCenter.default.removeObserver)
    }

    override convenience init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.init(asset: nil, image: nil, completionHandler: nil)
    }

    public required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
