//  Created by Geoff Pado on 3/3/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

protocol ImageRequester: Actor {
    func requestImage(for asset: PHAsset) async -> UIImage?
}

actor LibraryImageRequester: ImageRequester {
    private let imageManager: any ImageManager
    init(imageManager: any ImageManager = PHImageManager.default()) {
        self.imageManager = imageManager
    }

    func requestImage(for asset: PHAsset) async -> UIImage? {
        return await withCheckedContinuation { continuation in
            imageManager.requestImage(
                for: asset,
                targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight),
                contentMode: .default,
                options: nil
            ) { image, _ in
                continuation.resume(returning: image)
            }
        }
    }
}
