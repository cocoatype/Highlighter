//  Created by Geoff Pado on 5/31/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import ErrorHandling
import Photos
import UIKit

class PhotoLibraryDataSourceAssetsProvider: NSObject {
    var photosCount: Int { allPhotos.count }
    init(collection: Collection) {
        self.collection = collection
    }

    func item(atIndex index: Int) -> PhotoLibraryItem {
        return .asset(allPhotos[index])
    }

    func cell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssetPhotoLibraryViewCell.identifier, for: indexPath)
        guard let photoCell = cell as? AssetPhotoLibraryViewCell else {
            ErrorHandling.crash("Got incorrect type of cell for photo picker: \(String(describing: type(of: cell)))")
        }

        photoCell.asset = allPhotos[indexPath.item]
        return photoCell
    }

    private(set) lazy var allPhotos: PHFetchResult<PHAsset> = self.fetchAllPhotos()
    func handleChangedResult(_ result: PHFetchResult<PHAsset>) { self.allPhotos = result }

    static func photo(withIdentifier identifier: String) -> PHAsset? {
        return PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil).firstObject
    }

    private func fetchAllPhotos() -> PHFetchResult<PHAsset> {
        guard let collection = collection as? AssetCollection else { return PHFetchResult<PHAsset>() }
        return collection.assets
    }

    private let collection: Collection
}
