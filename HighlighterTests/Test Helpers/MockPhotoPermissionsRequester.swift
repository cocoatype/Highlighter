//  Created by Geoff Pado on 4/13/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Photos
@testable import Highlighter

class MockPhotoPermissionsRequester: PhotoPermissionsRequester {
    init(desiredAuthorizationStatus: PHAuthorizationStatus) {
        self.desiredAuthorizationStatus = desiredAuthorizationStatus
        super.init()
    }

    var desiredAuthorizationStatus: PHAuthorizationStatus
    override func requestAuthorization(_ handler: @escaping (PHAuthorizationStatus) -> Void) {
        handler(desiredAuthorizationStatus)
    }

    override func authorizationStatus() -> PHAuthorizationStatus {
        return desiredAuthorizationStatus
    }
}
