//  Created by Geoff Pado on 4/13/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Photos

@MainActor
public protocol PhotoPermissionsRequester {
    func authorizationStatus() -> PHAuthorizationStatus
    func requestAuthorization() async -> PHAuthorizationStatus
}

public struct PhotoLibraryPermissionsRequester: PhotoPermissionsRequester {
    public init() {
        self.init(photoLibraryType: PHPhotoLibrary.self)
    }

    private let photoLibraryType: any PhotoLibrary.Type
    init(photoLibraryType: any PhotoLibrary.Type) {
        self.photoLibraryType = photoLibraryType
    }

    public func authorizationStatus() -> PHAuthorizationStatus {
        photoLibraryType.authorizationStatus(for: .readWrite)
    }

    public func requestAuthorization() async -> PHAuthorizationStatus {
        return await photoLibraryType.requestAuthorization(for: .readWrite)
    }
}

protocol PhotoLibrary {
    static func authorizationStatus(for type: PHAccessLevel) -> PHAuthorizationStatus
    static func requestAuthorization(for type: PHAccessLevel) async -> PHAuthorizationStatus
}

extension PHPhotoLibrary: PhotoLibrary {}
