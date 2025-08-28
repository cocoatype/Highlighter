//  Created by Geoff Pado on 8/6/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Photos

@available(iOS 26.0, *)
@Observable
class LibraryObserver: NSObject, PHPhotoLibraryChangeObserver {
    var assets: [PhotoAsset]
    override init() {
        self.assets = PhotoAsset.assets(from: PHAsset.fetchAssets(with: nil))

        super.init()
        PHPhotoLibrary.shared().register(self)
    }

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    func photoLibraryDidChange(_ changeInstance: PHChange) {}
}
