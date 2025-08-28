//  Created by Geoff Pado on 8/28/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Photos

protocol PhotoLibrary: Sendable {
    static func authorizationStatus(for type: PHAccessLevel) -> PHAuthorizationStatus
    static func requestAuthorization(for type: PHAccessLevel) async -> PHAuthorizationStatus
}

extension PHPhotoLibrary: PhotoLibrary {}
