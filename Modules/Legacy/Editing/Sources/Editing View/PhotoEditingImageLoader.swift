//  Created by Geoff Pado on 11/14/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

/// Loads the full-size image for a photo library asset.
@MainActor
final class PhotoEditingImageLoader {
    /// Requests the full-size image for `asset`, calling `completion` on the
    /// main actor once a non-degraded image is available.
    func requestImage(for asset: PHAsset, completion: @escaping @MainActor (UIImage) -> Void) {
        let options = StandardImageRequestOptions()
        imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: options) { image, info in
            let isDegraded = (info?[PHImageResultIsDegradedKey] as? NSNumber)?.boolValue ?? false
            guard let image = image, isDegraded == false else { return }

            DispatchQueue.main.async {
                completion(image)
            }
        }
    }

    private let imageManager = PHImageManager()
}
