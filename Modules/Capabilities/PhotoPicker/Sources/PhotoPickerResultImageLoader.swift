//  Created by Geoff Pado on 3/3/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Photos
import PhotosUI
import UIKit

struct PhotoPickerResultImageLoader: Sendable {
    private let assetFetcher: any AssetFetcher
    private let imageRequester: any ImageRequester
    init(
        assetFetcher: any AssetFetcher = LibraryAssetFetcher(),
        imageRequester: any ImageRequester = LibraryImageRequester()
    ) {
        self.assetFetcher = assetFetcher
        self.imageRequester = imageRequester
    }

    func loadImage(for result: PickerResult) async -> UIImage? {
        guard let assetID = result.assetIdentifier,
              let asset = assetFetcher.fetchAsset(withIdentifier: assetID)
        else { return nil }

        return await imageRequester.requestImage(for: asset)
    }
}
