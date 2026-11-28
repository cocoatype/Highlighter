//  Created by Geoff Pado on 5/13/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

#if canImport(UIKit)
import UIKit

public extension DetectableImage {
    /// Creates a detectable image from a `UIImage`.
    ///
    /// - Throws: `DetectableImageError.missingCGImage` if the image isn't
    ///   backed by a `CGImage`.
    init(_ image: UIImage) throws {
        guard let cgImage = image.cgImage else { throw DetectableImageError.missingCGImage }
        self.init(cgImage: cgImage, orientation: image.imageOrientation.cgImagePropertyOrientation)
    }
}

public enum DetectableImageError: Error {
    case missingCGImage
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
#endif
