//  Created by Geoff Pado on 4/8/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

class PhotoLibraryDataSource: NSObject, UICollectionViewDataSource, PHPhotoLibraryChangeObserver {
    override init() {
        super.init()
        PHPhotoLibrary.shared().register(self)
    }

    weak var libraryView: PhotoLibraryView?

    // MARK: Data Source

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if #available(iOS 13.0, *) {
            return allPhotos.count + 1
        } else {
            return allPhotos.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.row < allPhotos.count else {
            return documentScannerCell(for: collectionView, at: indexPath)
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssetPhotoLibraryViewCell.identifier, for: indexPath)
        guard let photoCell = cell as? AssetPhotoLibraryViewCell else {
            fatalError("Got incorrect type of cell for photo picker: \(String(describing: type(of: cell)))")
        }

        photoCell.asset = allPhotos[indexPath.item]

        return cell
    }

    // MARK: Document Scanning

    private func documentScannerCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        guard #available(iOS 13.0, *) else {
            fatalError("Tried to display a document scanner cell on iOS version prior to iOS 13.0")
        }

        return collectionView.dequeueReusableCell(withReuseIdentifier: DocumentScannerPhotoLibraryViewCell.identifier, for: indexPath)
    }

    // MARK: Photos

    private lazy var allPhotos: PHFetchResult<PHAsset> = self.fetchAllPhotos()

    static func photo(withIdentifier identifier: String) -> PHAsset? {
        return PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil).firstObject
    }

    func photo(at indexPath: IndexPath) -> PHAsset {
        return allPhotos[indexPath.item]
    }

    var lastItemIndexPath: IndexPath {
        let lastItemIndex = allPhotos.count - 1
        return IndexPath(row: lastItemIndex, section: 0)
    }

    private func fetchAllPhotos() -> PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        return PHAsset.fetchAssets(with: fetchOptions)
    }

    // MARK: Photo Library Changes

    func photoLibraryDidChange(_ changeInstance: PHChange) {
        if let changes = changeInstance.changeDetails(for: allPhotos) {
            allPhotos = changes.fetchResultAfterChanges

            DispatchQueue.main.async { [weak self] in
                guard let dataSource = self, let libraryView = dataSource.libraryView else { return }

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
    }
}
