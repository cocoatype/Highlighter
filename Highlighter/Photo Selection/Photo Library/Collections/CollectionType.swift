//  Created by Geoff Pado on 5/16/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Photos

enum CollectionType {
    case favorites
    case library
    case recents
    case screenshots
    case userAlbum

    var assetCollectionType: PHAssetCollectionType {
        switch self {
        case .favorites, .library, .recents, .screenshots: return .smartAlbum
        case .userAlbum: return .album
        }
    }

    var assetCollectionSubtype: PHAssetCollectionSubtype {
        switch self {
        case .favorites: return .smartAlbumFavorites
        case .library: return .smartAlbumUserLibrary
        case .recents: return .smartAlbumRecentlyAdded
        case .screenshots: return .smartAlbumScreenshots
        case .userAlbum: return .any
        }
    }

    var fetchResult: PHFetchResult<PHAssetCollection> {
        return PHAssetCollection.fetchAssetCollections(with: assetCollectionType, subtype: assetCollectionSubtype, options: nil)
    }

    var defaultCollection: Collection {
        guard let defaultCollection = fetchResult.firstObject else {
            assertionFailure("Did not return a default collection for type: \(self)")
            return Collection(PHAssetCollection())
        }

        return Collection(defaultCollection)
    }
}
