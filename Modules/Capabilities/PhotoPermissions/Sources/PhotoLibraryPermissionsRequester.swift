//  Created by Geoff Pado on 8/28/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Photos

struct PhotoLibraryPermissionsRequester: PhotoPermissionsRequester {
    init() {
        self.init(photoLibraryType: PHPhotoLibrary.self)
    }

    private let photoLibraryType: any PhotoLibrary.Type
    init(photoLibraryType: any PhotoLibrary.Type) {
        self.photoLibraryType = photoLibraryType
    }

    func authorizationStatus() -> PHAuthorizationStatus {
        photoLibraryType.authorizationStatus(for: .readWrite)
    }

    func requestAuthorization() async -> PHAuthorizationStatus {
        return await photoLibraryType.requestAuthorization(for: .readWrite)
    }
}
