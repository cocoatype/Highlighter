//  Created by Geoff Pado on 6/26/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Foundation
import ImageIO
import UniformTypeIdentifiers

extension CGImageDestination {
    static func create(
        data: NSMutableData,
        fileType: UTType,
        count: Int = 1
    ) -> CGImageDestination? {
        return CGImageDestinationCreateWithData(
            data,
            fileType.identifier as CFString,
            count,
            nil
        )
    }

    func add(_ image: CGImage) {
        CGImageDestinationAddImage(self, image, nil)
    }

    func finalize() throws {
        guard CGImageDestinationFinalize(self) else {
            throw CGImageDestinationError.finalizeFailed
        }
    }
}

enum CGImageDestinationError: Error {
    case finalizeFailed
}
