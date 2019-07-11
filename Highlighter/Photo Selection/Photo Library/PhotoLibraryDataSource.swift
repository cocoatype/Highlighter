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
        return allPhotos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoLibraryViewCell.identifier, for: indexPath)
        guard let photoCell = cell as? PhotoLibraryViewCell else {
            fatalError("Got incorrect type of cell for photo picker: \(String(describing: type(of: cell)))")
        }

        photoCell.asset = allPhotos[indexPath.item]

        return cell
    }

    // MARK: Photos

    private lazy var allPhotos: PHFetchResult<PHAsset> = self.fetchAllPhotos()

    static func photo(withIdentifier identifier: String) -> PHAsset? {
        return PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil).firstObject
    }

    func photo(at indexPath: IndexPath) -> PHAsset {
        return allPhotos[indexPath.item]
    }

    private func fetchAllPhotos() -> PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
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
