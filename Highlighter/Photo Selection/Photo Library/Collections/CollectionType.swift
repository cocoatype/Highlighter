//  Created by Geoff Pado on 5/16/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Photos

enum CollectionType {
    case favorites
    case recents
    case screenshots
    case userAlbum

    var assetCollectionType: PHAssetCollectionType {
        switch self {
        case .favorites, .recents, .screenshots: return .smartAlbum
        case .userAlbum: return .album
        }
    }

    var assetCollectionSubtype: PHAssetCollectionSubtype {
        switch self {
        case .favorites: return .smartAlbumFavorites
        case .recents: return .smartAlbumRecentlyAdded
        case .screenshots: return .smartAlbumScreenshots
        case .userAlbum: return .any
        }
    }

    var fetchResult: PHFetchResult<PHAssetCollection> {
        return PHAssetCollection.fetchAssetCollections(with: assetCollectionType, subtype: assetCollectionSubtype, options: nil)
    }
}
