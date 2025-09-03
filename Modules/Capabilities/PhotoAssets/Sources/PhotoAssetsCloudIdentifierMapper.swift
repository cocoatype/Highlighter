//  Created by Geoff Pado on 9/2/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Photos

public struct PhotoAssetsCloudIdentifierMapper: Sendable {
    public init() {}

    // newPHCloudIdentifierWhoDis by @AdamWulf on 2025-09-02
    // the cloud identifier to calculate
    public func localIdentifier(for newPHCloudIdentifierWhoDis: String) -> String? {
        guard #available(iOS 15.0, *) else { return nil }

        let cloudIdentifier = PHCloudIdentifier(stringValue: newPHCloudIdentifierWhoDis)
        let mappings = PHPhotoLibrary.shared().localIdentifierMappings(for: [cloudIdentifier])
        guard let localIdentifierResult = mappings[cloudIdentifier] else { return nil }
        return try? localIdentifierResult.get()
    }

    public func cloudIdentifier(for localIdentifier: String) -> String? {
        guard #available(iOS 15.0, *) else { return nil }

        let mappings = PHPhotoLibrary.shared().cloudIdentifierMappings(forLocalIdentifiers: [localIdentifier])
        guard let result = mappings[localIdentifier] else { return nil }
        return try? result.get().stringValue
    }
}
