//  Created by Geoff Pado on 4/8/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Defaults
import Editing
import Photos
import Purchasing
import UIKit

class PhotoLibraryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDragDelegate, UIDropInteractionDelegate, PHPhotoLibraryChangeObserver {
    init(collection: Collection = CollectionType.library.defaultCollection) {
        self.dataSource = PhotoLibraryDataSource(collection)
        super.init(nibName: nil, bundle: nil)

        PHPhotoLibrary.shared().register(self)

        navigationItem.title = Self.navigationItemTitle
        navigationItem.rightBarButtonItem = SettingsBarButtonItem.standard

        hideDocumentScannerObserver = NotificationCenter.default.addObserver(forName: _hideDocumentScanner.valueDidChange, object:nil, queue: nil) { [weak self] _ in
            self?.libraryView.reloadData()
        }
    }

    override func loadView() {
        libraryView.dataSource = dataSource
        libraryView.delegate = self
        libraryView.dragDelegate = self

        let dropInteraction = UIDropInteraction(delegate: self)
        libraryView.addInteraction(dropInteraction)

        view = libraryView

        Task {
            await reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if shouldScrollToBottom {
            libraryView.layoutIfNeeded()
            libraryView.scrollToItem(at: dataSource.lastItemIndexPath, at: .bottom, animated: false)
            shouldScrollToBottom = false
        }

        let cellCount = libraryView.numberOfItems(inSection: 0)
        if cellCount != dataSource.itemsCount {
            Task {
                await reloadData()
            }
        }
    }

    func reloadData() async {
        await dataSource.refresh()
        libraryView.reloadData()
    }

    var collection: Collection {
        get { return dataSource.collection }
        set(newCollection) {
            let newDataSource = PhotoLibraryDataSource(newCollection)
            dataSource = newDataSource
            shouldScrollToBottom = true

            Task {
                await reloadData()
            }
        }
    }

    // MARK: UICollectionViewDragDelegate

    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = dataSource.item(at: indexPath)
        guard case .asset(let asset) = item else { return [] }

        let userActivity = EditingUserActivity(assetLocalIdentifier: asset.localIdentifier)
        let dragItemProvider = NSItemProvider(object: userActivity)

        let dragItem = UIDragItem(itemProvider: dragItemProvider)
        dragItem.localObject = asset
        return [dragItem]
    }

    // MARK: UIDropInteractionDelegate

    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        guard session.items.count == 1 else { return false }
        guard session.canLoadObjects(ofClass: UIImage.self) else { return false }

        return true
    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }

    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: UIImage.self) { [weak self] dropItems in
            guard let image = (dropItems.first as? UIImage) else { return }
            self?.photoEditorPresenter?.presentPhotoEditingViewController(for: image, redactions: nil, animated: true, completionHandler: nil)
        }
    }

    // MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch dataSource.item(at: indexPath) {
        case .asset(let asset):
            photoEditorPresenter?.presentPhotoEditingViewController(for: asset, redactions: nil, animated: true)
        case .documentScan:
            documentScannerPresenter?.presentDocumentCameraViewController()
        case .limitedLibrary:
            limitedLibraryPresenter?.presentLimitedLibrary()
        }
    }

    // MARK: Photo Library Changes

    func photoLibraryDidChange(_ change: PHChange) {
        DispatchQueue.main.async { [unowned self] in
            assert(self.libraryView.dataSource === self.dataSource, "Library view's data source is wrong!")
            self.dataSource.calculateChange(in: self.libraryView, from: change)
        }
    }

    // MARK: Boilerplate

    private static let navigationItemTitle = NSLocalizedString("PhotoSelectionViewController.navigationItemTitle", comment: "Navigation title for the photo selector")

    @Defaults.Value(key: .hideDocumentScanner) private var hideDocumentScanner: Bool
    private var dataSource: PhotoLibraryDataSource {
        didSet {
            libraryView.dataSource = dataSource
        }
    }
    private let libraryView = PhotoLibraryView()
    private var hideDocumentScannerObserver: Any?
    private var shouldScrollToBottom = true

    deinit {
        hideDocumentScannerObserver.map { NotificationCenter.default.removeObserver($0) }
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
