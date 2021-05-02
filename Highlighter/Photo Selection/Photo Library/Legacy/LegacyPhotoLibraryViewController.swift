//  Created by Geoff Pado on 4/8/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import Photos
import UIKit

class LegacyPhotoLibraryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDragDelegate, UIDropInteractionDelegate, PHPhotoLibraryChangeObserver {
    init(collection: Collection = CollectionType.library.defaultCollection) {
        self.dataSource = PhotoLibraryDataSource(collection)
        super.init(nibName: nil, bundle: nil)

        PHPhotoLibrary.shared().register(self)

        navigationItem.title = Self.navigationItemTitle
        navigationItem.rightBarButtonItem = SettingsBarButtonItem.standard
        NotificationCenter.default.addObserver(forName: Purchaser.stateDidChange, object: nil, queue: .main) { [weak self] notification in
            guard let purchaser = notification.object as? Purchaser, case .purchased = purchaser.state else { return }
            self?.libraryView?.reloadData()
        }
    }

    override func loadView() {
        let libraryView = LegacyPhotoLibraryView()
        libraryView.dataSource = dataSource
        libraryView.delegate = self
        libraryView.dragDelegate = self
//        dataSource.libraryView = libraryView

        let dropInteraction = UIDropInteraction(delegate: self)
        libraryView.addInteraction(dropInteraction)

        view = libraryView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let libraryView = libraryView,
           libraryView.contentOffset.y <= 0 {
            libraryView.layoutIfNeeded()
            libraryView.scrollToItem(at: dataSource.lastItemIndexPath, at: .bottom, animated: false)
        }
    }

    var collection: Collection {
        get { return dataSource.collection }
        set(newCollection) {
            let newDataSource = PhotoLibraryDataSource(newCollection)
            dataSource = newDataSource
            libraryView?.dataSource = dataSource
            libraryView?.reloadData()
        }
    }

    // MARK: UICollectionViewDragDelegate

    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard #available(iOS 13.0, *) else { return [] }

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
            guard #available(iOS 13.0, *) else { break }
            documentScannerPresenter?.presentDocumentCameraViewController()
        case .limitedLibrary: break
        }
    }

    // MARK: Photo Library Changes

    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: dataSource.allPhotos) else { return }
//        guard let changes = dataSource.changeDetails(for: changeInstance) else { return }

        DispatchQueue.main.async { [weak self] in
            guard let dataSource = self?.dataSource else { return }
            dataSource.itemsCountPublisher.send(dataSource.itemsCount)

            guard let libraryView = self?.libraryView else { return }

            if changes.hasIncrementalChanges {
                libraryView.performBatchUpdates({ [unowned libraryView, changes] in
                    if let removed = changes.removedIndexes {
                        libraryView.deleteItems(at: removed.map { IndexPath(item: $0, section:0) })
                    }
                    if let inserted = changes.insertedIndexes {
                        libraryView.insertItems(at: inserted.map { IndexPath(item: $0, section:0) })
                    }
                    if let changed = changes.changedIndexes {
                        libraryView.reloadItems(at: changed.map { IndexPath(item: $0, section:0) })
                    }

                    changes.enumerateMoves { fromIndex, toIndex in
                        libraryView.moveItem(at: IndexPath(item: fromIndex, section: 0),
                                             to: IndexPath(item: toIndex, section: 0))
                    }
                }, completion: nil)
            } else {
                libraryView.reloadData()
            }
        }
    }

    // MARK: Boilerplate

    private static let navigationItemTitle = NSLocalizedString("PhotoSelectionViewController.navigationItemTitle", comment: "Navigation title for the photo selector")

    private var dataSource: PhotoLibraryDataSource
    private var libraryView: LegacyPhotoLibraryView? { return view as? LegacyPhotoLibraryView }
    private var purchaseStateObserver: Any?

    deinit {
        purchaseStateObserver.map(NotificationCenter.default.removeObserver)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
