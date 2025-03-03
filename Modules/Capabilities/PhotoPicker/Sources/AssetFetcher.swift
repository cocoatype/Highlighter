//  Created by Geoff Pado on 3/3/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Photos

protocol AssetFetcher: Sendable {
    func fetchAsset(withIdentifier: String) -> PHAsset?
}

struct LibraryAssetFetcher: AssetFetcher {
    typealias FetchAssets = @Sendable ([String], PHFetchOptions?) -> PHFetchResult<PHAsset>
    private let fetchAssets: FetchAssets
    init(fetchAssets: @escaping FetchAssets = PHAsset.fetchAssets(withLocalIdentifiers:options:)) {
        self.fetchAssets = fetchAssets
    }

    func fetchAsset(withIdentifier identifier: String) -> PHAsset? {
        fetchAssets([identifier], nil).firstObject
    }
}
