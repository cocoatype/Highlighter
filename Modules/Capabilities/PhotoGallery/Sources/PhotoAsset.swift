//  Created by Geoff Pado on 8/6/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Photos

struct PhotoAsset: Identifiable {
    var id: String { asset.localIdentifier }
    let asset: PHAsset
    init(_ asset: PHAsset) {
        self.asset = asset
    }

    static func assets(from result: PHFetchResult<PHAsset>) -> [PhotoAsset] {
        var assets = [PhotoAsset]()
        result.enumerateObjects { asset, _, _ in
            assets.append(PhotoAsset(asset))
        }
        return assets
    }
}
