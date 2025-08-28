//  Created by Geoff Pado on 8/6/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Photos
import SwiftUI
import UIKit

struct AssetImageLoader: ImageLoader {
    private let imageManager = PHImageManager()
    func loadImage(for asset: PhotoAsset) async throws -> Image {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat

        return try await withCheckedThrowingContinuation { continuation in
            imageManager.requestImage(
                for: asset.underlyingAsset,
                targetSize: CGSize(width: 300, height: 300),
                contentMode: .aspectFill,
                options: options) { uiImage, _ in
                    guard let uiImage else { return continuation.resume(throwing: Error.imageNotLoaded) }
                    let image = Image(uiImage: uiImage)
                    continuation.resume(returning: image)
                }
        }
    }

    enum Error: Swift.Error {
        case imageNotLoaded
    }

    struct Factory: ImageLoaderFactory {
        func newImageLoader() -> any ImageLoader {
            return AssetImageLoader()
        }
    }
}
