//  Created by Geoff Pado on 6/26/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import ImageIO
import UniformTypeIdentifiers

extension CGImageSource {
    static func create(_ data: Data) -> CGImageSource? {
        CGImageSourceCreateWithData(data as CFData, nil)
    }

    var type: UTType? {
        guard let sourceType = CGImageSourceGetType(self) else { return nil }
        return UTType(sourceType as String)
    }
}
