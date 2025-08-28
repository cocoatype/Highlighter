//  Created by Geoff Pado on 8/6/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Photos

struct PhotoAsset: Identifiable {
    var id: String { underlyingAsset.localIdentifier }
    let underlyingAsset: PHAsset
    init(_ underlyingAsset: PHAsset) {
        self.underlyingAsset = underlyingAsset
    }

    static func assets(from result: PHFetchResult<PHAsset>) -> [PhotoAsset] {
        var assets = [PhotoAsset]()
        result.enumerateObjects { asset, _, _ in
            assets.append(PhotoAsset(asset))
        }
        return assets
    }
}
