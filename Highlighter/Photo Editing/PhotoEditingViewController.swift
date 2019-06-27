//  Created by Geoff Pado on 4/15/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

class PhotoEditingViewController: UIViewController, UIScrollViewDelegate {
    init(asset: PHAsset? = nil, image: UIImage? = nil, completionHandler: ((UIImage) -> Void)? = nil) {
        self.asset = asset
        self.image = image
        self.completionHandler = completionHandler
        super.init(nibName: nil, bundle: nil)

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(AppViewController.dismissPhotoEditingViewController))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(PhotoEditingViewController.sharePhoto))
        updateToolbarItems(animated: false)

        redactionChangeObserver = NotificationCenter.default.addObserver(forName: PhotoEditingRedactionView.redactionsDidChange, object: nil, queue: .main, using: { [weak self] _ in
            self?.updateToolbarItems()
        })
    }

    override func loadView() {
        view = photoEditingView
    }

    override func viewWillAppear(_ animated: Bool) {
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

    private(set) var hasMadeEdits = false
    @objc func markHasMadeEdits() {
        hasMadeEdits = true
    }

    // MARK: Sharing

    var imageForExport: UIImage? {
        guard let image = photoEditingView.image else { return nil }
        let photoExporter = PhotoExporter(image: image, redactions: photoEditingView.redactions)
        return photoExporter.exportedImage
    }

    @objc func sharePhoto() {
        guard let exportedImage = imageForExport else { return }

        let activityController = UIActivityViewController(activityItems: [exportedImage], applicationActivities: nil)
        activityController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        activityController.completionWithItemsHandler = { [weak self] _, completed, _, _ in
            self?.hasMadeEdits = false
            Defaults.numberOfSaves = Defaults.numberOfSaves + 1
            AppRatingsPrompter.displayRatingsPrompt()
        }

        present(activityController, animated: true)
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
        let undoToolItem = UIBarButtonItem(image: UIImage(named: "Undo"), style: .plain, target: self, action: #selector(PhotoEditingViewController.undo))
        undoToolItem.isEnabled = editingUndoManager.canUndo

        let redoToolItem = UIBarButtonItem(image: UIImage(named: "Redo"), style: .plain, target: self, action: #selector(PhotoEditingViewController.redo))
        redoToolItem.isEnabled = editingUndoManager.canRedo

        let spacerItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let highlighterToolIcon = photoEditingView.highlighterTool.image
        let highlighterToolItem = UIBarButtonItem(image: highlighterToolIcon, style: .plain, target: self, action: #selector(toggleHighlighterTool))
        setToolbarItems([undoToolItem, redoToolItem, spacerItem, highlighterToolItem], animated: animated)
    }

    // MARK: Undo/Redo

    let editingUndoManager = UndoManager()
    override var undoManager: UndoManager? {
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

    // MARK: Image

    private(set) var image: UIImage? {
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
    }

    // MARK: Boilerplate

    let completionHandler: ((UIImage) -> Void)?

    private let asset: PHAsset?
    private let imageManager = PHImageManager()
    private let textRectangleDetector = TextRectangleDetector()
    private let photoEditingView = PhotoEditingView()
    private var redactionChangeObserver: Any?

    deinit {
        redactionChangeObserver.map(NotificationCenter.default.removeObserver)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
