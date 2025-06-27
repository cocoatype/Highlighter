//  Created by Geoff Pado on 6/26/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import ImageIO
import UniformTypeIdentifiers

extension CGImageSource {
    var imageOrientation: CGImagePropertyOrientation? {
        guard let properties = CGImageSourceCopyPropertiesAtIndex(self, 0, nil) as? [String: Any],
              let orientationValue = properties[kCGImagePropertyOrientation as String] as? UInt32
        else { return nil }

        return CGImagePropertyOrientation(rawValue: orientationValue)
    }

    var image: CGImage? {
        return CGImageSourceCreateImageAtIndex(self, 0, nil)
    }
}
