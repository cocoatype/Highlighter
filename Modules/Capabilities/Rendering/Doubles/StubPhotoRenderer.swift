//  Created by Geoff Pado on 6/26/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import UIKit

import Redactions
import Rendering

public struct StubPhotoRenderer: PhotoRenderer {
    public init() {}

    public func render(image: UIImage, redactions: [Redaction]) async throws -> UIImage {
        guard let image = UIImage(systemName: "bolt")
        else { throw StubPhotoRendererError.systemImageMissing }

        return image
    }

    public func render(imageSource: CGImageSource, redactions: [Redaction]) async throws -> CGImage {
        guard let image = UIImage(systemName: "bolt"),
              let cgImage = image.cgImage
        else { throw StubPhotoRendererError.systemImageMissing }

        return cgImage
    }
}

enum StubPhotoRendererError: Error {
    case systemImageMissing
}
