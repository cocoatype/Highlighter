//  Created by Geoff Pado on 11/27/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import CoreGraphics
import ImageIO
import Testing

#if canImport(UIKit)
import UIKit
#endif

@testable import Detections

struct DetectableImageTests {
    @Test(arguments: [
        CGImagePropertyOrientation.up,
        .down,
        .upMirrored,
        .downMirrored,
    ])
    func uprightOrientationsKeepPixelSize(orientation: CGImagePropertyOrientation) throws {
        let image = try DetectableImage(cgImage: Self.makeCGImage(width: 4, height: 2), orientation: orientation)

        #expect(image.pixelSize == CGSize(width: 4, height: 2))
        #expect(image.orientedSize == CGSize(width: 4, height: 2))
    }

    @Test(arguments: [
        CGImagePropertyOrientation.left,
        .right,
        .leftMirrored,
        .rightMirrored,
    ])
    func sidewaysOrientationsSwapOrientedSize(orientation: CGImagePropertyOrientation) throws {
        let image = try DetectableImage(cgImage: Self.makeCGImage(width: 4, height: 2), orientation: orientation)

        #expect(image.pixelSize == CGSize(width: 4, height: 2))
        #expect(image.orientedSize == CGSize(width: 2, height: 4))
    }

    @Test func defaultOrientationIsUp() throws {
        let image = try DetectableImage(cgImage: Self.makeCGImage(width: 1, height: 1))
        #expect(image.orientation == .up)
    }

    #if canImport(UIKit)
    @Test func uiImageOrientationIsCarriedOver() throws {
        let cgImage = try Self.makeCGImage(width: 4, height: 2)
        let uiImage = UIImage(cgImage: cgImage, scale: 2, orientation: .right)

        let image = try DetectableImage(uiImage)

        #expect(image.orientation == .right)
        let uiImagePixelSize = CGSize(
            width: uiImage.size.width * uiImage.scale,
            height: uiImage.size.height * uiImage.scale
        )
        #expect(image.orientedSize == uiImagePixelSize)
    }

    @Test func uiImageWithoutCGImageThrows() {
        #expect(throws: DetectableImageError.missingCGImage) {
            try DetectableImage(UIImage())
        }
    }
    #endif

    private static func makeCGImage(width: Int, height: Int) throws -> CGImage {
        let context = try #require(CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ))
        return try #require(context.makeImage())
    }
}
