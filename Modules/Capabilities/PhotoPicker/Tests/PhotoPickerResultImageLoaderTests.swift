//  Created by Geoff Pado on 3/3/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import PhotosUI
import Testing
import UIKit

@testable import PhotoPicker

@MainActor
struct PhotoPickerResultImageLoaderTests {
    @Test
    func loadImageForNilIdentifier() async {
        struct NilResult: PickerResult {
            var assetIdentifier: String? { nil }
        }

        let loader = PhotoPickerResultImageLoader()
        let image = await loader.loadImage(for: NilResult())

        #expect(image == nil)
    }

    @Test func loadImageForMissingAsset() async {
        struct MissingResult: PickerResult {
            var assetIdentifier: String? = "assetIdentifier"
        }

        struct MissingFetcher: AssetFetcher {
            func fetchAsset(withIdentifier: String) -> PHAsset? { nil }
        }

        let loader = PhotoPickerResultImageLoader(
            assetFetcher: MissingFetcher()
        )
        let image = await loader.loadImage(for: MissingResult())

        #expect(image == nil)
    }

    @Test func loadImage() async {
        struct Result: PickerResult {
            var assetIdentifier: String? = "assetIdentifier"
        }

        struct Fetcher: AssetFetcher {
            func fetchAsset(withIdentifier: String) -> PHAsset? { PHAsset() }
        }

        actor Requester: ImageRequester {
            func requestImage(for asset: PHAsset) async -> UIImage? {
                return UIImage(systemName: "bolt")
            }
        }

        let loader = PhotoPickerResultImageLoader(
            assetFetcher: Fetcher(),
            imageRequester: Requester()
        )
        let image = await loader.loadImage(for: Result())

        #expect(image == UIImage(systemName: "bolt"))
    }
}
