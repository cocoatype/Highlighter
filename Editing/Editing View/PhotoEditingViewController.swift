//  Created by Geoff Pado on 4/15/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

public class PhotoEditingViewController: UIViewController, UIScrollViewDelegate, UIColorPickerViewControllerDelegate, UIPopoverPresentationControllerDelegate {
    public init(asset: PHAsset? = nil, image: UIImage? = nil, redactions: [Redaction]? = nil, completionHandler: ((UIImage) -> Void)? = nil) {
        self.asset = asset
        self.image = image
        self.completionHandler = completionHandler
        super.init(nibName: nil, bundle: nil)

        definesPresentationContext = true

        photoEditingView.add(redactions ?? [])
        updateToolbarItems(animated: false)

        redactionChangeObserver = NotificationCenter.default.addObserver(forName: PhotoEditingRedactionView.redactionsDidChange, object: nil, queue: .main, using: { [weak self] _ in
            self?.updateToolbarItems()
        })

        updateToolbarItems(animated: false)

        userActivity = EditingUserActivity()

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

        updateToolbarItems(animated: false)

        let options = StandardImageRequestOptions()

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

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateToolbarItems(animated: false)
        updateSeekPresentation()
    }

    open override var canBecomeFirstResponder: Bool { return true }

    // MARK: Edit Protection

    private(set) public var hasMadeEdits = false
    @objc func markHasMadeEdits() {
        hasMadeEdits = true
    }

    public func clearHasMadeEdits() {
        hasMadeEdits = false
    }

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
        let actionSet = ActionSet(for: self, undoManager: undoManager, selectedTool: photoEditingView.highlighterTool, sizeClass: traitCollection.horizontalSizeClass)

        navigationItem.setLeftBarButtonItems(actionSet.leadingNavigationItems, animated: false)
        navigationItem.setRightBarButtonItems(actionSet.trailingNavigationItems, animated: false)
        setToolbarItems(actionSet.toolbarItems, animated: false)

        navigationController?.setToolbarHidden(actionSet.toolbarItems.count == 0, animated: false)

        userActivity?.needsSave = true
    }

    // MARK: Seek and Destroy

    private let seekBar = SeekBar()

    private var isSeeking = false {
        didSet {
            seekBar.isSeeking = isSeeking
        }
    }

    open override var inputAccessoryView: UIView? {
        return seekBar
    }

    @objc public func toggleSeeking(_ sender: Any) {
        if isSeeking {
            cancelSeeking(sender)
        } else {
            startSeeking(sender)
        }
    }

    @objc public func startSeeking(_ sender: Any) {
        isSeeking = true

        #if targetEnvironment(macCatalyst)
        present(DesktopSeekViewController(), animated: true, completion: nil)
        #else
        if traitCollection.horizontalSizeClass == .regular {
            let seekViewController = TabletSeekViewController()
            seekViewController.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
            seekViewController.popoverPresentationController?.delegate = self
            present(seekViewController, animated: true, completion: nil)
        } else {
            seekBar.becomeFirstResponder()
        }
        #endif
    }

    @objc public func cancelSeeking(_ sender: Any) {
        isSeeking = false

        photoEditingView.seekPreviewObservations = []

        #if targetEnvironment(macCatalyst)
        if presentedViewController is DesktopSeekViewController {
            dismiss(animated: true, completion: nil)
        }
        #else
        seekBar.resignFirstResponder()
        seekBar.searchTextField?.text = nil

        if presentedViewController is TabletSeekViewController {
            dismiss(animated: true, completion: nil)
        }

        becomeFirstResponder()
        #endif
    }

    @objc public func finishSeeking(_ sender: Any) {
        photoEditingView.redact(photoEditingView.seekPreviewObservations, joinSiblings: false)
        if photoEditingView.seekPreviewObservations.count > 0 { markHasMadeEdits() }
        cancelSeeking(sender)
    }

    @objc public func seekBarDidChangeText(_ sender: UISearchTextField) {
        guard let wordObservations = photoEditingView.wordObservations,
              let text = sender.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        else { return }

        photoEditingView.seekPreviewObservations = wordObservations.matching([text])
    }

    open override var canResignFirstResponder: Bool { true }

    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.cancelSeeking(presentationController)
    }

    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    private func updateSeekPresentation() {
        #warning("#225: Move text between tablet and phone presentations")
        cancelSeeking(self)
    }

    // MARK: Color Picker

    @objc public func showColorPicker(_ sender: Any) {
        if traitCollection.userInterfaceIdiom == .mac {
            ColorPanel.shared.makeKeyAndOrderFront(sender)
        } else if let barButtonItem = sender as? UIBarButtonItem {
            let picker = ColorPickerViewController()
            picker.delegate = self
            picker.popoverPresentationController?.barButtonItem = barButtonItem
            present(picker, animated: true, completion: nil)
        }
    }

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
    private let undoKeyCommand = UIKeyCommand(action: #selector(PhotoEditingViewController.undo), input: "z", modifierFlags: .command, discoverabilityTitle: PhotoEditingViewController.undoKeyCommandDiscoverabilityTitle)
    private let redoKeyCommand = UIKeyCommand(action: #selector(PhotoEditingViewController.redo), input: "z", modifierFlags: [.command, .shift], discoverabilityTitle: PhotoEditingViewController.redoKeyCommandDiscoverabilityTitle)
    
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

        textRectangleDetector.detectText(in: image) { [weak self] recognizedTextObservations in
            guard let observations = recognizedTextObservations else { return }
            Task { [weak self] in
                await MainActor.run { [weak self] in
                    self?.updateWordObservations(from: observations)
                    self?.autoRedact(using: observations)
                }
            }
        }
    }

    @MainActor
    private func updateWordObservations(from textObservations: [RecognizedTextObservation]) {
        photoEditingView.wordObservations = textObservations.flatMap(\.allWordObservations)
    }

    @MainActor
    private func autoRedact(using textObservations: [RecognizedTextObservation]) {
        let matchingObservations = Defaults.autoRedactionsWordList.flatMap { word -> [WordObservation] in
            return textObservations.flatMap { observation -> [WordObservation] in
                observation.wordObservations(matching: word)
            }
        }

        if matchingObservations.count > 0 {
            photoEditingView.redact(matchingObservations, joinSiblings: false)
            markHasMadeEdits()
        }
    }

    // MARK: User Activity

    open override func updateUserActivityState(_ activity: NSUserActivity) {
        guard let editingActivity = (activity as? EditingUserActivity) else { return }
        if let asset = asset {
            editingActivity.assetLocalIdentifier = asset.localIdentifier
        } else if let representedURL = fileURLProvider?.representedFileURL {
            let accessGranted = representedURL.startAccessingSecurityScopedResource()
            defer { representedURL.stopAccessingSecurityScopedResource() }
            guard accessGranted else { return }

            editingActivity.imageBookmarkData = try? representedURL.bookmarkData()
        } else if let image = image {
            editingActivity.image = image
        }
        editingActivity.redactions = photoEditingView.redactions
    }

    // MARK: Sharing
    @objc public func sharePhoto(_ sender: Any) {
        let imageType = image?.type
        exportImage { [weak self] image in
            guard let exportedImage = image else { return }

            let representedURLName = "\(Self.defaultImageName).\(imageType?.preferredFilenameExtension ?? "png")"
            let temporaryURL = URL(fileURLWithPath: NSTemporaryDirectory())
                .appendingPathComponent(representedURLName)

            let data: Data?

            switch imageType {
            case .jpeg?:
                data = image?.jpegData(compressionQuality: 0.9)
            case .png?: fallthrough
            default:
                data = image?.pngData()
            }

            let activityItems: [Any]
            if let data = data, let _ = try? data.write(to: temporaryURL) {
                activityItems = [temporaryURL]
            } else {
                activityItems = [exportedImage]
            }

            let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            activityController.completionWithItemsHandler = { [weak self] _, completed, _, _ in
                self?.hasMadeEdits = false
                Defaults.numberOfSaves = Defaults.numberOfSaves + 1
                DispatchQueue.main.async { [weak self] in
                    self?.chain(selector: #selector(PhotoEditingActions.displayAppRatingsPrompt))
                }
            }

            DispatchQueue.main.async { [weak self] in
                activityController.popoverPresentationController?.barButtonItem = self?.navigationItem.rightBarButtonItem
                self?.present(activityController, animated: true)
            }
        }
    }

    // MARK: Boilerplate

    public let completionHandler: ((UIImage) -> Void)?
    public var redactions: [Redaction] { return photoEditingView.redactions }

    public static let defaultImageName = NSLocalizedString("PhotoEditingViewController.defaultImageName", comment: "Default name when saving the image on macOS")
    private static let redoKeyCommandDiscoverabilityTitle = NSLocalizedString("BasePhotoEditingViewController.redoKeyCommandDiscoverabilityTitle", comment: "Discovery title for the redo key command")
    private static let undoKeyCommandDiscoverabilityTitle = NSLocalizedString("BasePhotoEditingViewController.undoKeyCommandDiscoverabilityTitle", comment: "Discovery title for the undo key command")

    private let asset: PHAsset?
    private var colorObserver: Any?
    private let imageCache = RestorationImageCache()
    private let imageManager = PHImageManager()
    private let textRectangleDetector = TextDetector()
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

@objc protocol PhotoEditingActions: NSObjectProtocol {
    func dismissPhotoEditingViewController(_ sender: UIBarButtonItem)
    func displayAppRatingsPrompt()
}
