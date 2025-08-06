//  Created by Geoff Pado on 5/31/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

import FactoryKit

import AlbumsData
import ErrorHandling

public class PhotoLibraryDataSourceAssetsProvider: NSObject {
    var photosCount: Int { allPhotos.count }
    init(collection: PhotoCollection) {
        self.collection = collection
    }

    func item(atIndex index: Int) -> PhotoLibraryItem {
        return .asset(allPhotos[index])
    }

    @Injected(\.errorHandler) private var errorHandler
    func cell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssetPhotoLibraryViewCell.identifier, for: indexPath)
        guard let photoCell = cell as? AssetPhotoLibraryViewCell else {
            errorHandler.crash("Got incorrect type of cell for photo picker: \(String(describing: type(of: cell)))")
        }

        photoCell.asset = allPhotos[indexPath.item]
        return photoCell
    }

    private(set) lazy var allPhotos: PHFetchResult<PHAsset> = self.fetchAllPhotos()
    func handleChangedResult(_ result: PHFetchResult<PHAsset>) { self.allPhotos = result }

    public static func photo(withIdentifier identifier: String) -> PHAsset? {
        return PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil).firstObject
    }

    private func fetchAllPhotos() -> PHFetchResult<PHAsset> {
        return collection.assets
    }

    private let collection: PhotoCollection
}
