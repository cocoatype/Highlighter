//  Created by Geoff Pado on 4/22/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit
import UniformTypeIdentifiers

extension UIImage {
    public var type: UTType? {
        guard let imageTypeString = cgImage?.utType
        else { return nil }

        return UTType(imageTypeString as String)
    }
}

extension UIImage.Orientation {
    var cgImagePropertyOrientation: CGImagePropertyOrientation {
        switch self {
        case .up: return .up
        case .down: return .down
        case .left: return .left
        case .right: return .right
        case .upMirrored: return .upMirrored
        case .downMirrored: return .downMirrored
        case .leftMirrored: return .leftMirrored
        case .rightMirrored: return .rightMirrored
        @unknown default: return .up
        }
    }
}
