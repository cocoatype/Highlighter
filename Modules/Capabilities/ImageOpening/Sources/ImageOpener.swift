//  Created by Geoff Pado on 8/6/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import UIKit

public struct ImageOpener {
    public init() {}

    public func openImage(at url: URL) throws -> UIImage {
        guard url.startAccessingSecurityScopedResource() else {
            throw ImageOpeningError.securityScopeDenied
        }
        defer { url.stopAccessingSecurityScopedResource() }

        let imageData = try Data(contentsOf: url)
        guard let image = UIImage(data: imageData) else {
            throw ImageOpeningError.noImageFound
        }

        return image
    }
}
