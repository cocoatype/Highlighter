//  Created by Geoff Pado on 4/15/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

import FactoryKit

import DebugOverlay
import Defaults
import Redactions
import Tools
import UserActivities

public class PhotoEditingViewController: UIViewController, UIScrollViewDelegate {
    public init(
        asset: PHAsset? = nil,
        image: UIImage? = nil,
        redactions: [Redaction]? = nil,
        completionHandler: ((UIImage) -> Void)? = nil
    ) {
        self.asset = asset
        self.image = image
        self.completionHandler = completionHandler
        super.init(nibName: nil, bundle: nil)

        definesPresentationContext = true
        linkChainedResponders()

        photoEditingView.add(redactions ?? [])
        autoRedactor.onRedact = { [weak self] in self?.markHasMadeEdits() }
        toolbarController.updateToolbarItems(animated: false)

        userActivity = EditingUserActivity()

        embed(pencilMenuViewController)
    }

    open override func loadView() {
        view = photoEditingView
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        toolbarController.updateToolbarItems(animated: false)

        if image != nil {
            updateScrollView()
        } else if let asset = asset {
            imageLoader.requestImage(for: asset) { [weak self] image in
                self?.image = image
            }
        }
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard let previousTraitCollection,
              previousTraitCollection.horizontalSizeClass != traitCollection.horizontalSizeClass ||
                previousTraitCollection.verticalSizeClass != traitCollection.verticalSizeClass
        else { return }

        toolbarController.updateToolbarItems(animated: false)
        seekController.updateSeekPresentation()
    }

    open override var canBecomeFirstResponder: Bool { return true }

    // MARK: Responder Chain

    /// Helpers that handle actions on behalf of this view controller, in the
    /// order they appear in the responder chain after it.
    private var chainedResponders: [PhotoEditingChainedResponder] {
        [
            toolController,
            toolbarController,
            historyController,
            colorPickerController,
            seekController,
            autoRedactAccessController,
            shareController,
        ]
    }

    private func linkChainedResponders() {
        let responders = chainedResponders
        responders.forEach { $0.editingViewController = self }
        for (responder, successor) in zip(responders, responders.dropFirst()) {
            responder.successor = { [weak successor] in successor }
        }
        responders.last?.successor = { [weak self] in self?.superNext }
    }

    open override var next: UIResponder? { chainedResponders.first ?? super.next }
    private var superNext: UIResponder? { super.next }

    // MARK: Edit Protection

    private(set) public var hasMadeEdits = false
    @objc func markHasMadeEdits() {
        hasMadeEdits = true
    }

    public func clearHasMadeEdits() {
        hasMadeEdits = false
    }

    // MARK: Highlighters

    public var highlighterTool: HighlighterTool { return photoEditingView.highlighterTool }

    private lazy var toolController = PhotoEditingToolController(photoEditingView: photoEditingView)

    // MARK: Toolbar

    private lazy var toolbarController = PhotoEditingToolbarController(photoEditingView: photoEditingView, asset: asset)

    // MARK: Seek and Destroy

    private lazy var seekController = PhotoEditingSeekController(photoEditingView: photoEditingView)

    open override var inputAccessoryView: UIView? {
        return seekController.seekBar
    }

    open override var canResignFirstResponder: Bool { true }

    // MARK: Color Picker

    private lazy var colorPickerController = PhotoEditingColorPickerController(photoEditingView: photoEditingView)

    // MARK: Undo/Redo

    private let historyController = PhotoEditingHistoryController()
    public override var undoManager: UndoManager? { historyController.undoManager }

    // MARK: Auto Redact

    private let autoRedactAccessController = PhotoEditingAutoRedactAccessController()
    private lazy var autoRedactor = PhotoEditingAutoRedactor(photoEditingView: photoEditingView)

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

        guard let image else { return }
        textDetectionController.detectText(in: image)
    }

    private let imageLoader = PhotoEditingImageLoader()
    private lazy var textDetectionController = PhotoEditingTextDetectionController(photoEditingView: photoEditingView, autoRedactor: autoRedactor)

    // MARK: Zoom

    public var zoomScale: CGFloat {
        get { photoEditingView.zoomScale }
        set { photoEditingView.setZoomScale(newValue, animated: true) }
    }

    // MARK: User Activity

    open override func updateUserActivityState(_ activity: NSUserActivity) {
        guard let editingActivity = (activity as? EditingUserActivity) else { return }
        PhotoEditingUserActivityUpdater(
            asset: asset,
            representedFileURL: fileURLProvider?.representedFileURL,
            image: image,
            redactions: photoEditingView.redactions
        ).update(editingActivity)
    }

    // MARK: Sharing

    private lazy var shareController = PhotoEditingShareController(photoEditingView: photoEditingView, asset: asset)

    public var preparedURL: URL {
        get async throws { try await shareController.preparedURL }
    }

    @objc @MainActor public func showDebugPreferences(_ sender: Any) {
        guard #available(iOS 15, *) else { return }
        present(OverlayPreferencesHostingController(), animated: true)
    }

    // MARK: Pencil Menu

    private let pencilMenuViewController = PhotoEditingPencilMenuViewController()
    @objc func updatePencilMenu(_ sender: UIView, event: PhotoEditingWorkspacePencilEvent) {
        pencilMenuViewController.updateMenu(at: event.location?.converted(from: sender, to: view), phase: event.phase)
    }

    // MARK: Boilerplate

    @Injected(\.defaults) var defaults

    public let completionHandler: ((UIImage) -> Void)?
    public var redactions: [Redaction] { return photoEditingView.redactions }

    private let asset: PHAsset?
    private let photoEditingView = PhotoEditingScrollView()

    override convenience init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.init(asset: nil, image: nil, completionHandler: nil)
    }

    public required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }

    private typealias Strings = Editing.Strings.PhotoEditingViewController
}

@objc @MainActor public protocol PhotoEditingActions: NSObjectProtocol {
    func displayAppRatingsPrompt(_ sender: any WindowSceneProvider)
}
