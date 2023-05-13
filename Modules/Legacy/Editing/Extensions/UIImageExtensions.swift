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

    public var realSize: CGSize {
        switch imageOrientation {
        case .up, .down, .upMirrored, .downMirrored:
            return size
        case .left, .right, .leftMirrored, .rightMirrored:
            return CGSize(width: size.height, height: size.width)
        @unknown default:
            return size
        }
    }

    public func cgImage(scale: CGFloat) -> CGImage? {
        guard abs(scale - self.scale) >= 0.01
        else { return cgImage }

        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        let scaledImage = UIGraphicsImageRenderer(size: size, format: format).image { _ in
            self.draw(at: .zero)
        }
        return scaledImage.cgImage
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

    public var rotationAngle: CGFloat {
        switch self {
        case .up: return 0
        case .down: return .pi
        case .left: return  -1 * .pi / 2
        case .right: return .pi / 2
        case .upMirrored: return 0
        case .downMirrored: return .pi
        case .leftMirrored: return .pi / 2
        case .rightMirrored: return -1 * .pi / 2
        @unknown default: return 0
        }
    }
}
