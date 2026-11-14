//  Created by Geoff Pado on 4/15/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

import FactoryKit

import DebugOverlay
import Defaults
import Detections
import EditingToolbar
import ErrorHandling
import Exporting
import Geometry
import Logging
import MobileAutoRedactionsUI
import Observations
import Paywall
import Redactions
import Rendering
import Tools
import UserActivities

#warning("#61: Simplify this class")
// swiftlint:disable file_length
// swiftlint:disable:next type_body_length
public class PhotoEditingViewController: UIViewController, UIScrollViewDelegate, HighlighterToolSelectionHandler {
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
        updateToolbarItems(animated: false)

        redactionChangeObserver = NotificationCenter.default.addObserver(forName: PhotoEditingRedactionView.redactionsDidChange, object: nil, queue: .main, using: { [weak self] _ in
            self?.updateToolbarItems()
        })

        autoRedactor.onRedact = { [weak self] in self?.markHasMadeEdits() }

        hideAutoRedactionsChangeObserver = NotificationCenter.default.addObserver(for: Keys.hideAutoRedactions) { [weak self] in
            self?.updateToolbarItems()
        }

        updateToolbarItems(animated: false)

        userActivity = EditingUserActivity()

        embed(pencilMenuViewController)
    }

    open override func loadView() {
        view = photoEditingView
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateToolbarItems(animated: false)

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

        updateToolbarItems(animated: false)
        seekController.updateSeekPresentation()
    }

    open override var canBecomeFirstResponder: Bool { return true }

    // MARK: Responder Chain

    /// Helpers that handle actions on behalf of this view controller, in the
    /// order they appear in the responder chain after it.
    private var chainedResponders: [PhotoEditingChainedResponder] {
        [
            historyController,
            colorPickerController,
            seekController,
            autoRedactAccessController,
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

    @objc func toggleHighlighterTool() {
        select(photoEditingView.highlighterTool.next)
    }

    @objc public func selectHighlighterTool(_ sender: UICommand) {
        guard let index = sender.propertyList as? Int else { return }
        select(HighlighterTool.allCases[index])
    }

    @objc public func selectHighlighterTool(_ sender: Any, event: HighlighterToolSelectionEvent) {
        select(event.tool)
    }

    private func select(_ tool: HighlighterTool) {
        photoEditingView.highlighterTool = tool
        updateToolbarItems()
    }

    @objc public func refreshToolbarItems() { updateToolbarItems() }

    private func updateToolbarItems(animated: Bool = true) {
        let actionSet = ActionSet(for: self, undoManager: undoManager, selectedTool: photoEditingView.highlighterTool, sizeClass: traitCollection.horizontalSizeClass, currentColor: photoEditingView.color, asset: asset)

        if #available(iOS 16, *) {
            navigationItem.style = .editor

            navigationItem.leadingItemGroups = actionSet.leadingNavigationItems.map { $0.creatingFixedGroup() }
            navigationItem.centerItemGroups = actionSet.centerNavigationItems.map { $0.creatingFixedGroup() }
            navigationItem.trailingItemGroups = actionSet.trailingNavigationItems.map { $0.creatingFixedGroup() }
        } else {
            navigationItem.setLeftBarButtonItems(actionSet.leadingNavigationItems, animated: false)
            navigationItem.setRightBarButtonItems(actionSet.trailingNavigationItems, animated: false)
        }

        setToolbarItems(actionSet.toolbarItems, animated: animated)
        navigationController?.setToolbarHidden(actionSet.toolbarItems.count == 0, animated: animated)

        userActivity?.needsSave = true
    }

    private var shareBarButtonItem: UIBarButtonItem? {
        if #available(iOS 16, *) {
            return navigationItem.trailingItemGroups.flatMap { $0.barButtonItems }.first(where: { $0 is ShareBarButtonItem })
        } else {
            return navigationItem.rightBarButtonItems?.first(where: { $0 is ShareBarButtonItem })
        }
    }

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
    public var preparedURL: URL {
        get async throws {
            guard let image = photoEditingView.image else { throw PhotoEditingError.noEditingImage }
            return try await ExportingPreparer(image: image, asset: asset, redactions: redactions).preparedURL
        }
    }

    @objc @MainActor public func sharePhoto(_ sender: Any) {
        Task { [weak self] in
            guard let self else { return }
            do {
                guard let image else { throw PhotoEditingError.noEditingImage }
                let activityController = try await ExportingActivityController(image: image, asset: asset, redactions: photoEditingView.redactions)
                activityController.popoverPresentationController?.barButtonItem = shareBarButtonItem
                activityController.completionWithItemsHandler = { [weak self] _, _, _, _ in
                    self?.clearHasMadeEdits()
                    self?.chain(selector: #selector(PhotoEditingActions.displayAppRatingsPrompt))
                }
                present(activityController, animated: true)
            } catch {
                errorHandler.log(error, module: "Editing", type: "PhotoEditingViewController")
                let alert = PhotoExportErrorAlertFactory.alert(for: error)
                present(alert, animated: true)
            }
        }
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
    @Injected(\.errorHandler) var errorHandler
    @Injected(\.logger) var logger

    public let completionHandler: ((UIImage) -> Void)?
    public var redactions: [Redaction] { return photoEditingView.redactions }

    private let asset: PHAsset?
    private let photoEditingView = PhotoEditingScrollView()
    private var redactionChangeObserver: Any?
    private var hideAutoRedactionsChangeObserver: Any?

    deinit {
        [
            redactionChangeObserver,
            hideAutoRedactionsChangeObserver,
        ].forEach { $0.map(NotificationCenter.default.removeObserver) }
    }

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
    func displayAppRatingsPrompt(_ sender: WindowSceneProvider)
}
