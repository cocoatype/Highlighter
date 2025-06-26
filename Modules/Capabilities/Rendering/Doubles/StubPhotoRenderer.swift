//  Created by Geoff Pado on 6/26/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import UIKit

import Redactions
import Rendering

public struct StubPhotoRenderer: PhotoRenderer {
    public init() {}

    public func render(image: PhotoRendererImage, redactions: [Redaction]) async throws -> PhotoRendererImage {
        guard let image = UIImage(systemName: "bolt")
        else { throw StubPhotoRendererError.systemImageMissing }

        return image
    }
}

enum StubPhotoRendererError: Error {
    case systemImageMissing
}
