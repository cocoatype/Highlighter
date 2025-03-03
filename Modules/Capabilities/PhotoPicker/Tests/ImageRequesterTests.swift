//  Created by Geoff Pado on 3/3/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Photos
import Testing
import UIKit

@testable import PhotoPicker

struct ImageRequesterTests {
    @Test
    func requestImage() async {
        struct Manager: ImageManager {
            func requestImage(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions?, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
                resultHandler(UIImage(systemName: "bolt"), nil)
                return PHImageRequestID()
            }
        }

        let requester = LibraryImageRequester(imageManager: Manager())
        let result = await requester.requestImage(for: PHAsset())
        #expect(result == UIImage(systemName: "bolt"))
    }
}
