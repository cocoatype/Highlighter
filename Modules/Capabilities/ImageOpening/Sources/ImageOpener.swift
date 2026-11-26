//  Created by Geoff Pado on 8/6/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

#if canImport(UIKit)
import UIKit
#endif

public struct ImageOpener {
    public init() {}

    #if canImport(UIKit)
    public func openImage(at url: URL) throws -> UIImage {
        return try openImage(resource: url)
    }

    func openImage(resource: any SecureResource) throws -> UIImage {
        _ = resource.startAccessingSecurityScopedResource()
        defer { resource.stopAccessingSecurityScopedResource() }

        let imageData = try resource.data
        guard let image = UIImage(data: imageData) else {
            throw ImageOpeningError.noImageFound
        }

        return image
    }
    #endif
}
