//  Created by Geoff Pado on 9/2/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Photos

public struct PhotoAssetsRetriever: Sendable {
    public init() {}

    public func asset(
        forLocalIdentifier localIdentifier: String?,
        cloudIdentifier: String?
    ) -> PHAsset? {
        if let localIdentifier,
           let localAsset = asset(forLocalIdentifier: localIdentifier) {
            return localAsset
        } else if #available(iOS 15.0, *),
                  let cloudIdentifier,
                  let cloudAsset = asset(forCloudIdentifier: cloudIdentifier) {
            return cloudAsset
        } else {
            return nil
        }
    }

    private func asset(forLocalIdentifier localIdentifier: String) -> PHAsset? {
        return PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil).firstObject
    }

    private let cloudMapper = PhotoAssetsCloudIdentifierMapper()

    @available(iOS 15.0, *)
    private func asset(forCloudIdentifier cloudIdentifierString: String) -> PHAsset? {
        guard let localIdentifier = cloudMapper.localIdentifier(for: cloudIdentifierString) else { return nil }

        return asset(forLocalIdentifier: localIdentifier)
    }
}
