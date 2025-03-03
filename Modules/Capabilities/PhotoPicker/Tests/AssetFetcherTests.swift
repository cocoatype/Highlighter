//  Created by Geoff Pado on 3/3/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Photos
import Testing
import UIKit

@testable import PhotoPicker

struct AssetFetcherTests {
    @Test
    func fetchAsset() async {
        class FetchResult: PHFetchResult<PHAsset>, @unchecked Sendable {
            private let object: PHAsset
            init(object: PHAsset) {
                self.object = object
            }

            override var firstObject: PHAsset? { object }
        }

        let asset = PHAsset()
        let fetcher = LibraryAssetFetcher { identifiers, options in
            #expect(identifiers == ["assetID"])
            #expect(options == nil)
            return FetchResult(object: asset)
        }
        let result = fetcher.fetchAsset(withIdentifier: "assetID")
        #expect(result === asset)
    }
}
