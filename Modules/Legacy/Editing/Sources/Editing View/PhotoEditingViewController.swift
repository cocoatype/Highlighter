//  Created by Geoff Pado on 4/15/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import AutoRedactionsUI
import DebugOverlay
import Defaults
import Detections
import EditingToolbar
import ErrorHandling
import Exporting
import Geometry
import Observations
import Photos
import PurchaseMarketing
import Redactions
import Rendering
import Tools
import UIKit
import UserActivities

#warning("#61: Simplify this class")
// swiftlint:disable file_length
// swiftlint:disable:next type_body_length
public class PhotoEditingViewController: UIViewController, UIScrollViewDelegate, UIColorPickerViewControllerDelegate, UIPopoverPresentationControllerDelegate, HighlighterToolSelectionHandler {
    public init(
        asset: PHAsset? = nil,
        image: UIImage? = nil,
        redactions: [Redaction]? = nil,
        defaults: any DefaultsProvider = Defaults.provider,
        completionHandler: ((UIImage) -> Void)? = nil
    ) {
        self.asset = asset
        self.image = image
        self.completionHandler = completionHandler
        self.defaults = defaults
        super.init(nibName: nil, bundle: nil)

        definesPresentationContext = true

        photoEditingView.add(redactions ?? [])
        updateToolbarItems(animated: false)

        redactionChangeObserver = NotificationCenter.default.addObserver(forName: PhotoEditingRedactionView.redactionsDidChange, object: nil, queue: .main, using: { [weak self] _ in
            self?.updateToolbarItems()
        })

        viewerNamesAreNotRidiculous = NotificationCenter.default.addObserver(for: Keys.autoRedactionsSet) { [weak self] in
            self?.updateAutoRedactions()
        }

        thatsNotEvenValidSwiftMono = NotificationCenter.default.addObserver(for: Keys.autoRedactionsCategoryNames) { [weak self] in
            self?.updateAutoRedactions()
        }

        🥥 = NotificationCenter.default.addObserver(for: Keys.autoRedactionsCategoryAddresses) { [weak self] in
            self?.updateAutoRedactions()
        }

        phoneNumbersRedactionChangeObserver = NotificationCenter.default.addObserver(for: Keys.autoRedactionsCategoryPhoneNumbers) { [weak self] in
            self?.updateAutoRedactions()
        }

        hideAutoRedactionsChangeObserver = NotificationCenter.default.addObserver(for: Keys.hideAutoRedactions) { [weak self] in
            self?.updateToolbarItems()
        }

        updateToolbarItems(animated: false)

        userActivity = EditingUserActivity()

        #if targetEnvironment(macCatalyst)
        ColorPanel.shared.color = .black
        colorObserver = NotificationCenter.default.addObserver(forName: ColorPanel.colorDidChangeNotification, object: nil, queue: .main, using: { [weak self] notification in
            guard let colorPanel = notification.object as? ColorPanel else { return }
            self?.photoEditingView.color = colorPanel.color
        })
        #endif

        embed(pencilMenuViewController)
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

        guard let previousTraitCollection,
              previousTraitCollection.horizontalSizeClass != traitCollection.horizontalSizeClass ||
                previousTraitCollection.verticalSizeClass != traitCollection.verticalSizeClass
        else { return }

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
            present(seekViewController, animated: true)
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
        guard let text = sender.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        else { return }

        let redactedCharacterObservations = photoEditingView.redactableCharacterObservations.matching(text)
        photoEditingView.seekPreviewObservations = redactedCharacterObservations
    }

    open override var canResignFirstResponder: Bool { true }

    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        cancelSeeking(presentationController)
    }

    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    private func updateSeekPresentation() {
        #warning("#24: Move text between tablet and phone presentations")
        cancelSeeking(self)
    }

    // MARK: Color Picker

    @objc public func toggleColorPicker(_ sender: Any) {
        if let presentedViewController, presentedViewController is ColorPickerViewController {
            dismiss(animated: true)
        } else {
            showColorPicker(sender)
        }
    }

    @objc public func showColorPicker(_ sender: Any) {
        if traitCollection.userInterfaceIdiom == .mac {
            ColorPanel.shared.makeKeyAndOrderFront(sender)
        } else {
            let colorPickerItem: UIBarButtonItem
            if let barButtonItem = sender as? UIBarButtonItem {
                colorPickerItem = barButtonItem
            } else if let barButtonItem = findBarButtonItem({ $0 is ColorPickerBarButtonItem }) {
                colorPickerItem = barButtonItem
            } else { return }

            let picker = ColorPickerViewController()
            picker.delegate = self
            picker.popoverPresentationController?.barButtonItem = colorPickerItem
            present(picker, animated: true)
        }
    }

    public func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        photoEditingView.color = viewController.selectedColor
        updateToolbarItems()
    }

    @objc func selectedColorDidChange(_ sender: UIColorWell) {
        guard let color = sender.selectedColor else { return }
        photoEditingView.color = color
    }

    // MARK: Undo/Redo

    private let localUndoManager = UndoManager()
    public override var undoManager: UndoManager? { localUndoManager }

    @objc private func undo(_ sender: Any) {
        undoManager?.undo()
        updateToolbarItems()
    }

    @objc private func redo(_ sender: Any) {
        undoManager?.redo()
        updateToolbarItems()
    }

    // MARK: Auto Redact

    @objc private func showAutoRedactAccess(_ sender: Any) {
        present(
            PhotoEditingAutoRedactionsAccessProvider()
                .autoRedactionsAccessViewController { [weak self] in
                    if #available(iOS 16, *) {
                        self?.present(PurchaseMarketingHostingController(), animated: true)
                    }
                },
            animated: true
        )
    }

    @objc public func hideAutoRedactAccess(_ sender: Any) {
        guard presentedViewController is AutoRedactionsAccessNavigationController else { return }
        dismiss(animated: true)
    }

    @MainActor
    private func autoRedact() {
        let matchingObservations = matchingObservations(onlyActive: true)

        if matchingObservations.count > 0 {
            photoEditingView.redact(matchingObservations, joinSiblings: false)
            markHasMadeEdits()
        }
    }

    @MainActor
    private func removeAutoRedactions() {
        matchingObservations(onlyActive: false).forEach(photoEditingView.unredact)
    }

    @MainActor
    private func updateAutoRedactions() {
        // thisMeetingCouldHaveBeenAnEmail by @nutterfi on 2024-04-29
        // dontMailYourCats by @KaenAitch on 2024-04-29

        removeAutoRedactions()
        autoRedact()
    }

    // MARK: Key Commands

    #if targetEnvironment(macCatalyst)
    #else
    private let undoKeyCommand = UIKeyCommand(action: #selector(PhotoEditingViewController.undo), input: "z", modifierFlags: .command, discoverabilityTitle: Strings.undoKeyCommandDiscoverabilityTitle)
    private let redoKeyCommand = UIKeyCommand(action: #selector(PhotoEditingViewController.redo), input: "z", modifierFlags: [.command, .shift], discoverabilityTitle: Strings.redoKeyCommandDiscoverabilityTitle)

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

        guard let image else { return }
        Task { [weak self] in
            guard let self else { return }
            do {
                let textObservations = try await textRectangleDetector.detectText(in: image)
                photoEditingView.textObservations = textObservations
            } catch { ErrorHandler().log(error) }
        }

        Task { [weak self] in
            guard let self else { return }
            do {
                let recognizedTextObservations = try await textRectangleDetector.recognizeText(in: image)
                updateRecognizedTextObservations(from: recognizedTextObservations)
                autoRedact()
            } catch { ErrorHandler().log(error) }
        }
    }

    @MainActor
    private func updateRecognizedTextObservations(from textObservations: [RecognizedTextObservation]) {
        // store recognized text observations
        photoEditingView.recognizedTextObservations = textObservations
    }

    private func matchingObservations(onlyActive: Bool) -> [any TextObservation] {
        let wordObservations = tuBrute
            .filter { onlyActive ? $0.value : true }
            .keys
            .flatMap { word -> [CharacterObservation] in
                return photoEditingView.redactableCharacterObservations.matching(word)
            }
        var taggingFunctions = [(String) -> [Substring]]()

        if autoRedactionsCategoryNames || onlyActive == false {
            taggingFunctions.append( Category.names.getFuncyInSwizzleTown)
        }

        if autoRedactionsCategoryAddresses || onlyActive == false {
            taggingFunctions.append( Category.addresses.getFuncyInSwizzleTown)
        }

        if autoRedactionsCategoryPhoneNumbers || onlyActive == false {
            taggingFunctions.append( Category.phoneNumbers.getFuncyInSwizzleTown)
        }

        let combinedObservations = photoEditingView.redactableCharacterObservations.byUUID

        let categoryObservations = combinedObservations
            .values
            .compactMap(CombinedCharacterObservation.init)
            .flatMap { combinedObservation in
                taggingFunctions
                    .map { function in function(combinedObservation.associatedString) }
                    .map {
                        let matchingObservations = combinedObservation.characterObservations(with: $0)
                        let combinedShape = MinimumAreaShapeFinder.minimumAreaShape(for: matchingObservations.map(\.bounds))
                        return CharacterObservation(bounds: combinedShape, textObservationUUID: combinedObservation.textObservationUUID)
                    }
            }

        return wordObservations + categoryObservations
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

    var defaults: any DefaultsProvider

    // tuBrute by @AdamWulf on 2024-04-29
    // the auto-redactions word list
    private var tuBrute: [String: Bool] {
        defaults.value(for: Keys.autoRedactionsSet) ?? [:]
    }
    private var hideAutoRedactions: Bool {
        defaults.value(for: Keys.hideAutoRedactions)
    }
    private var autoRedactionsCategoryNames: Bool {
        defaults.value(for: Keys.autoRedactionsCategoryNames)
    }
    private var autoRedactionsCategoryAddresses: Bool {
        defaults.value(for: Keys.autoRedactionsCategoryAddresses)
    }
    private var autoRedactionsCategoryPhoneNumbers: Bool {
        defaults.value(for: Keys.autoRedactionsCategoryPhoneNumbers)
    }

    public let completionHandler: ((UIImage) -> Void)?
    public var redactions: [Redaction] { return photoEditingView.redactions }

    private let asset: PHAsset?
    private var colorObserver: Any?
    private let imageManager = PHImageManager()
    private let textRectangleDetector = TextDetector()
    private let photoEditingView = PhotoEditingView()
    private var redactionChangeObserver: Any?
    private var hideAutoRedactionsChangeObserver: Any?

    // viewerNamesAreNotRidiculous by @KaenAitch on 2024-04-29
    // the change observer for the auto-redactions word list
    private var viewerNamesAreNotRidiculous: Any?

    // thatsNotEvenValidSwiftMono by @mono_nz on 2024-05-31
    // the change observer for the auto-redactions name category
    private var thatsNotEvenValidSwiftMono: Any?

    // 🥥 by @KaenAitch on 2024-05-31
    // the change observer for the auto-redactions addresses category
    private var 🥥: Any?

    private var phoneNumbersRedactionChangeObserver: Any?

    deinit {
        [
            colorObserver,
            redactionChangeObserver,
            viewerNamesAreNotRidiculous,
            hideAutoRedactionsChangeObserver,
            thatsNotEvenValidSwiftMono,
            🥥,
            phoneNumbersRedactionChangeObserver,
        ].forEach { $0.map(NotificationCenter.default.removeObserver) }
    }

    override convenience init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.init(asset: nil, image: nil, completionHandler: nil)
    }

    public required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }

    private typealias Strings = EditingStrings.PhotoEditingViewController
}

@objc protocol PhotoEditingActions: NSObjectProtocol {
    func displayAppRatingsPrompt(_ sender: Any)
}
