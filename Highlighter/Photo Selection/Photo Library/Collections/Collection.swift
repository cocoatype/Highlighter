//  Created by Geoff Pado on 5/16/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Editing
import Photos
import UIKit

struct Collection {
    var assets: PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        return PHAsset.fetchAssets(in: assetCollection, options: fetchOptions)
    }
    var assetCount: Int { return assets.count }
    var icon: UIImage? {
        switch assetCollection.assetCollectionSubtype {
        case .smartAlbumFavorites: return Icons.favoritesCollection
        case .smartAlbumRecentlyAdded, .smartAlbumUserLibrary: return Icons.recentsCollection
        case .smartAlbumScreenshots: return Icons.screenshotsCollection
        default: return nil
        }
    }
    var keyAssets: PHFetchResult<PHAsset>
    { return PHAsset.fetchKeyAssets(in: assetCollection, options: nil) ?? PHFetchResult<PHAsset>() }
    var title: String? { return assetCollection.localizedTitle }

    init(_ assetCollection: PHAssetCollection) {
        self.assetCollection = assetCollection
    }

    private let assetCollection: PHAssetCollection
}
