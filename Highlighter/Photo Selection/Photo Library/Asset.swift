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
    }

    // MARK: Image Loading

    static let imageManager = PHImageManager.default()

    private var requestID: PHImageRequestID?

    func fetchImage(completionHandler: @escaping ((UIImage?) -> Void)) {
        guard image == nil, requestID == nil else { return }

        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .opportunistic

        requestID = Self.imageManager.requestImage(for: photoAsset, targetSize: CGSize(width: photoAsset.pixelWidth, height: photoAsset.pixelHeight), contentMode: .aspectFill, options: options) { image, _ in
            completionHandler(image)
        }
    }

    func startFetchingImage() {
        fetchImage { [weak self] image in
            self?.image = image
        }
    }

    func cancelFetchingImage() {
        guard let requestID = requestID else { return }
        Self.imageManager.cancelImageRequest(requestID)
    }
}
