//  Created by Geoff Pado on 7/27/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Photos
import SwiftUI

@available(iOS 14.0, *)
class Asset: ObservableObject {
    @Published var image: UIImage?
    let photoAsset: PHAsset
    init(_ asset: PHAsset) {
        self.photoAsset = asset

        fetchImage { [weak self] fetchedImage in
            self?.image = fetchedImage
        }
    }

    // MARK: Image Loading

    static let imageManager = PHImageManager.default()

    func fetchImage(completionHandler: @escaping ((UIImage?) -> Void)) {
        Self.imageManager.requestImage(for: photoAsset, targetSize: CGSize(width: photoAsset.pixelWidth, height: photoAsset.pixelHeight), contentMode: .aspectFill, options: nil) { image, _ in
            completionHandler(image)
        }
    }
}
