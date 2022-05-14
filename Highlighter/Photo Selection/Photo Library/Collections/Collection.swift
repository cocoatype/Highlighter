//  Created by Geoff Pado on 5/16/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Editing
import Photos
import UIKit

struct CollectionSection {
    let title: String
    let collections: [Collection]
}

protocol Collection {
    var title: String? { get }
    var icon: UIImage? { get }
    var identifier: String { get }
}

struct AssetCollection: Collection {
    var assets: PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        return PHAsset.fetchAssets(in: assetCollection, options: fetchOptions)
    }
    var assetCount: Int { return assets.count }
    var assetCollectionSubtype: PHAssetCollectionSubtype { assetCollection.assetCollectionSubtype }
    var icon: UIImage? {
        switch assetCollection.assetCollectionSubtype {
        case .smartAlbumFavorites: return Icons.favoritesCollection
        case .smartAlbumRecentlyAdded, .smartAlbumUserLibrary: return Icons.recentsCollection
        case .smartAlbumScreenshots: return Icons.screenshotsCollection
        default: return Icons.standardCollection
        }
    }
    var keyAssets: PHFetchResult<PHAsset>
    { return PHAsset.fetchKeyAssets(in: assetCollection, options: nil) ?? PHFetchResult<PHAsset>() }
    var identifier: String { return assetCollection.localIdentifier }
    var title: String? { return assetCollection.localizedTitle }

    init(_ assetCollection: PHAssetCollection) {
        self.assetCollection = assetCollection
    }

    private let assetCollection: PHAssetCollection
}

struct EmptyCollection: Collection {
    var title: String? { nil }
    var icon: UIImage? { nil }
    var identifier: String { "" }
}
