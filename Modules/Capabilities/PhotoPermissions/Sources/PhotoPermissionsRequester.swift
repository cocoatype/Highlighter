//  Created by Geoff Pado on 4/13/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Photos

@MainActor
public class PhotoPermissionsRequester: NSObject {
    public func authorizationStatus() -> PHAuthorizationStatus {
        PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }

    public func requestAuthorization() async -> PHAuthorizationStatus {
        return await PHPhotoLibrary.requestAuthorization(for: .readWrite)
    }
}
