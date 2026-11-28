//  Created by Geoff Pado on 11/27/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import CoreGraphics
import ImageIO

/// An image to detect or recognize text in, without depending on UIKit or AppKit.
public struct DetectableImage: Sendable {
    /// The image's pixels, before `orientation` is applied.
    public let cgImage: CGImage

    /// How `cgImage` should be rotated or mirrored to display upright.
    public let orientation: CGImagePropertyOrientation

    public init(cgImage: CGImage, orientation: CGImagePropertyOrientation = .up) {
        self.cgImage = cgImage
        self.orientation = orientation
    }

    /// The image's size in pixels, before `orientation` is applied.
    var pixelSize: CGSize {
        CGSize(width: Double(cgImage.width), height: Double(cgImage.height))
    }

    /// The image's size in pixels, after `orientation` is applied.
    var orientedSize: CGSize {
        switch orientation {
        case .left, .right, .leftMirrored, .rightMirrored:
            return CGSize(width: pixelSize.height, height: pixelSize.width)
        case .up, .down, .upMirrored, .downMirrored:
            return pixelSize
        @unknown default:
            return pixelSize
        }
    }
}
