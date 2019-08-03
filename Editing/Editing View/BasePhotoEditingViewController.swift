//  Created by Geoff Pado on 4/15/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

open class BasePhotoEditingViewController: UIViewController, UIScrollViewDelegate {
    public init(asset: PHAsset? = nil, image: UIImage? = nil, completionHandler: ((UIImage) -> Void)? = nil) {
        self.asset = asset
        self.image = image
        self.completionHandler = completionHandler
        super.init(nibName: nil, bundle: nil)

        updateToolbarItems(animated: false)

        redactionChangeObserver = NotificationCenter.default.addObserver(forName: PhotoEditingRedactionView.redactionsDidChange, object: nil, queue: .main, using: { [weak self] _ in
            self?.updateToolbarItems()
        })
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

    public var imageForExport: UIImage? {
        guard let image = photoEditingView.image else { return nil }
        let photoExporter = PhotoExporter(image: image, redactions: photoEditingView.redactions)
        return photoExporter.exportedImage
    }

    // MARK: Highlighters

    @objc func toggleHighlighterTool() {
        let currentTool = photoEditingView.highlighterTool
        let allTools = HighlighterTool.allCases
        let currentToolIndex = allTools.firstIndex(of: currentTool) ?? allTools.startIndex
        let nextToolIndex = (currentToolIndex + 1) % allTools.count
        let nextTool = allTools[nextToolIndex]
        photoEditingView.highlighterTool = nextTool
        updateToolbarItems()
    }

    private func updateToolbarItems(animated: Bool = true) {
        let undoToolItem = UIBarButtonItem(image: Icons.undo, style: .plain, target: self, action: #selector(BasePhotoEditingViewController.undo))
        undoToolItem.isEnabled = editingUndoManager.canUndo

        let redoToolItem = UIBarButtonItem(image: Icons.redo, style: .plain, target: self, action: #selector(BasePhotoEditingViewController.redo))
        redoToolItem.isEnabled = editingUndoManager.canRedo

        let spacerItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let highlighterToolIcon = photoEditingView.highlighterTool.image
        let highlighterToolItem = UIBarButtonItem(image: highlighterToolIcon, style: .plain, target: self, action: #selector(toggleHighlighterTool))
        setToolbarItems([undoToolItem, redoToolItem, spacerItem, highlighterToolItem], animated: animated)
    }

    // MARK: Undo/Redo

    let editingUndoManager = UndoManager()
    open override var undoManager: UndoManager? {
        return editingUndoManager
    }

    @objc private func undo() {
        editingUndoManager.undo()
        updateToolbarItems()
    }

    @objc private func redo() {
        editingUndoManager.redo()
        updateToolbarItems()
    }

    // MARK: Key Commands

    private let undoKeyCommand = UIKeyCommand(input: "z", modifierFlags: .command, action: #selector(BasePhotoEditingViewController.undo), discoverabilityTitle: BasePhotoEditingViewController.undoKeyCommandDiscoverabilityTitle)
    private let redoKeyCommand = UIKeyCommand(input: "z", modifierFlags: [.command, .shift], action: #selector(BasePhotoEditingViewController.redo), discoverabilityTitle: BasePhotoEditingViewController.redoKeyCommandDiscoverabilityTitle)

    open override var keyCommands: [UIKeyCommand]? {
        return [undoKeyCommand, redoKeyCommand]
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
            let blacklist = ["Black", "Highlighter"]
            textRectangleDetector.detectWords(in: image) { [weak self] recognizedTextObservations in
                guard let observations = recognizedTextObservations else { return }
                let matchingObservations = observations.filter { blacklist.contains($0.string) }

                DispatchQueue.main.async {
                    self?.photoEditingView.redact(matchingObservations)
                }
            }
        }
    }

    // MARK: Boilerplate

    public let completionHandler: ((UIImage) -> Void)?

    private static let undoKeyCommandDiscoverabilityTitle = NSLocalizedString("BasePhotoEditingViewController.undoKeyCommandDiscoverabilityTitle", comment: "Discovery title for the undo key command")
    private static let redoKeyCommandDiscoverabilityTitle = NSLocalizedString("BasePhotoEditingViewController.redoKeyCommandDiscoverabilityTitle", comment: "Discovery title for the redo key command")

    private let asset: PHAsset?
    private let imageManager = PHImageManager()
    private let textRectangleDetector = TextRectangleDetector()
    private let photoEditingView = PhotoEditingView()
    private var redactionChangeObserver: Any?

    deinit {
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
