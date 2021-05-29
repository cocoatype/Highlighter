//  Created by Geoff Pado on 4/8/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Combine
import ErrorHandling
import Photos
import SwiftUI
import UIKit
import VisionKit

protocol LibraryDataSource {
    var itemsCount: Int { get }
    func item(at index: Int) -> PhotoLibraryItem
}

class PhotoLibraryDataSource: NSObject, LibraryDataSource, UICollectionViewDataSource {
    let collection: Collection
    init(_ collection: Collection) {
        self.collection = collection
        super.init()
    }

    // MARK: Data Source

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch item(at: indexPath) {
        case .asset(_):
            return assetCell(for: collectionView, at: indexPath)
        case .documentScan:
            return documentScannerCell(for: collectionView, at: indexPath)
        case .limitedLibrary:
            return limitedLibraryCell(for: collectionView, at: indexPath)
        }
    }

    private func assetCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssetPhotoLibraryViewCell.identifier, for: indexPath)
        guard let photoCell = cell as? AssetPhotoLibraryViewCell else {
            ErrorHandling.crash("Got incorrect type of cell for photo picker: \(String(describing: type(of: cell)))")
        }

        photoCell.asset = allPhotos[indexPath.item]
        return photoCell
    }

    // MARK: Document Scanning

    private var shouldShowDocumentScannerCell: Bool {
        guard #available(iOS 13.0, *),
              let hasPurchased = try? PreviousPurchasePublisher.hasUserPurchasedProduct().get(),
              hasPurchased == true
        else { return false }
        return VNDocumentCameraViewController.isSupported
    }

    private func documentScannerCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        guard #available(iOS 13.0, *) else {
            ErrorHandling.crash("Tried to display a document scanner cell on iOS version prior to iOS 13.0")
        }

        return collectionView.dequeueReusableCell(withReuseIdentifier: DocumentScannerPhotoLibraryViewCell.identifier, for: indexPath)
    }

    // MARK: Limited Library

    private func limitedLibraryCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        guard #available(iOS 14.0, *) else {
            ErrorHandling.crash("Tried to display a limited library cell on iOS version prior to iOS 14.0")
        }

        return collectionView.dequeueReusableCell(withReuseIdentifier: LimitedLibraryPhotoLibraryViewCell.identifier, for: indexPath)
    }

    // MARK: Photos

    private let permissionsRequester = PhotoPermissionsRequester()

    private(set) lazy var allPhotos: PHFetchResult<PHAsset> = self.fetchAllPhotos()
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
}

@available(iOS 14.0, *)
extension PhotoLibraryDataSource: ObservableObject {
    
}

enum PhotoLibraryItem {
    case asset(PHAsset)
    case documentScan
    case limitedLibrary
}
