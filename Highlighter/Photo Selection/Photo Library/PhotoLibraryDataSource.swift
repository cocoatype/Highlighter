//  Created by Geoff Pado on 4/8/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Combine
import Photos
import SwiftUI
import UIKit
import VisionKit

protocol LibraryDataSource {
    var itemsCount: Int { get }
    func item(at index: Int) -> PhotoLibraryItem
}

class PhotoLibraryDataSource: NSObject, LibraryDataSource, PHPhotoLibraryChangeObserver, UICollectionViewDataSource {
    private let collection: Collection
    init(_ collection: Collection) {
        self.collection = collection
        super.init()

        PHPhotoLibrary.shared().register(self)
    }

    weak var libraryView: LegacyPhotoLibraryView?

    // MARK: Data Source

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.row < photosCount else {
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

    private var shouldShowDocumentScannerCell: Bool {
        guard #available(iOS 13.0, *) else { return false }
        guard case .purchased = Purchaser().state else { return false }
        return VNDocumentCameraViewController.isSupported
    }

    private func documentScannerCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        guard #available(iOS 13.0, *) else {
            fatalError("Tried to display a document scanner cell on iOS version prior to iOS 13.0")
        }

        return collectionView.dequeueReusableCell(withReuseIdentifier: DocumentScannerPhotoLibraryViewCell.identifier, for: indexPath)
    }

    // MARK: Photos

    private let permissionsRequester = PhotoPermissionsRequester()

    private lazy var allPhotos: PHFetchResult<PHAsset> = self.fetchAllPhotos()
    private var photosCount: Int { return allPhotos.count }
    var itemsCount: Int { photosCount + extraItems.count }
    var itemsCountPublisher = CurrentValueSubject<Int, Never>(0)

    var extraItems: [PhotoLibraryItem] {
        var extraItems = [PhotoLibraryItem]()

        if shouldShowDocumentScannerCell {
            extraItems.append(.documentScan)
        }

        if #available(iOS 14.0, *), permissionsRequester.authorizationStatus() == .limited {
            extraItems.append(.limitedLibrary)
        }

        return extraItems
    }

    static func photo(withIdentifier identifier: String) -> PHAsset? {
        return PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil).firstObject
    }

    func item(at index: Int) -> PhotoLibraryItem {
        guard index < photosCount else { return extraItems[index - photosCount] }
        return .asset(allPhotos[index])
    }
    
    func item(at indexPath: IndexPath) -> PhotoLibraryItem {
        return item(at: indexPath.item)
    }

    var lastItemIndexPath: IndexPath {
        let lastItemIndex = photosCount - 1
        return IndexPath(row: lastItemIndex, section: 0)
    }

    private func fetchAllPhotos() -> PHFetchResult<PHAsset> {
        guard let collection = collection as? AssetCollection else { return PHFetchResult<PHAsset>() }
        let assets = collection.assets
        itemsCountPublisher.send(assets.count + extraItems.count)
        return assets
    }

    // MARK: Photo Library Changes

    func photoLibraryDidChange(_ changeInstance: PHChange) {
        if let changes = changeInstance.changeDetails(for: allPhotos) {
            allPhotos = changes.fetchResultAfterChanges

            DispatchQueue.main.async { [weak self] in
                guard let dataSource = self else { return }
                dataSource.itemsCountPublisher.send(dataSource.itemsCount)

                guard let libraryView = dataSource.libraryView else { return }

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

@available(iOS 14.0, *)
extension PhotoLibraryDataSource: ObservableObject {
    
}

enum PhotoLibraryItem {
    case asset(PHAsset)
    case documentScan
    case limitedLibrary
}
