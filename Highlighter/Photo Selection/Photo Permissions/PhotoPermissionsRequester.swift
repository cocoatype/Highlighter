//  Created by Geoff Pado on 4/13/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Photos

class PhotoPermissionsRequester: NSObject {
    func authorizationStatus() -> PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }

    func requestAuthorization(_ handler: @escaping (PHAuthorizationStatus) -> Void) {
        PHPhotoLibrary.requestAuthorization { authorizationStatus in
            DispatchQueue.main.async {
                handler(authorizationStatus)
            }
        }
    }
}
