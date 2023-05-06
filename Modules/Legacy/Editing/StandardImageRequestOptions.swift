//  Created by Geoff Pado on 5/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Photos

class StandardImageRequestOptions: PHImageRequestOptions {
    override init() {
        super.init()
        version = .current
        deliveryMode = .highQualityFormat
        isNetworkAccessAllowed = true
    }
}
