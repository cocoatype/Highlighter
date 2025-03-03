//  Created by Geoff Pado on 3/3/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Photos
import Testing

@testable import PhotoPermissions

@MainActor
struct PhotoLibraryPermissionsRequesterTests {
    @Test
    func authorizationStatus() {
        #expect(PhotoLibraryPermissionsRequester(photoLibraryType: MockPhotoLibrary.self).authorizationStatus() == .authorized)
    }

    @Test
    func requestAuthorization() async {
        await #expect(PhotoLibraryPermissionsRequester(photoLibraryType: MockPhotoLibrary.self).requestAuthorization() == .authorized)
    }

    enum MockPhotoLibrary: PhotoLibrary {
        static func authorizationStatus(for type: PHAccessLevel) -> PHAuthorizationStatus {
            response(for: type)
        }

        static func requestAuthorization(for type: PHAccessLevel) async -> PHAuthorizationStatus {
            response(for: type)
        }

        private static func response(for type: PHAccessLevel) -> PHAuthorizationStatus {
            switch type {
            case .readWrite: .authorized
            case .addOnly: .denied
            @unknown default: .notDetermined
            }
        }
    }
}
