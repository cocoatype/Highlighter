//  Created by Geoff Pado on 5/13/23.
//  Copyright © 2023 Cocoatype, LLC. All rights reserved.

import CoreGraphics
import Testing

import Geometry

@testable import Brushes

struct BrushStampFactoryTests {
    private static let shapes = [
        // regular
        Shape(bottomLeft: CGPoint(x: 0, y: 100), bottomRight: CGPoint(x: 100, y: 100), topLeft: CGPoint(x: 0, y: 0), topRight: CGPoint(x: 100, y: 0)),
        // vertically flipped
        Shape(bottomLeft: CGPoint(x: 0, y: 0), bottomRight: CGPoint(x: 100, y: 0), topLeft: CGPoint(x: 0, y: 100), topRight: CGPoint(x: 100, y: 100)),
        // horizontally flipped
        Shape(bottomLeft: CGPoint(x: 100, y: 100), bottomRight: CGPoint(x: 0, y: 100), topLeft: CGPoint(x: 100, y: 0), topRight: CGPoint(x: 0, y: 0)),
        // doubly flipped
        Shape(bottomLeft: CGPoint(x: 100, y: 0), bottomRight: CGPoint(x: 0, y: 0), topLeft: CGPoint(x: 100, y: 100), topRight: CGPoint(x: 0, y: 100)),
    ]

    private static let red = CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1)

    @Test(arguments: shapes, [1, 2, 3] as [CGFloat])
    func brushImagesAreScaledToShapeHeight(shape: Shape, scale: CGFloat) throws {
        let (startImage, endImage) = try BrushStampFactory.brushImages(for: shape, color: Self.red, scale: scale)

        #expect(startImage.height == Int(100 * scale))
        #expect(endImage.height == Int(100 * scale))
        #expect(startImage.width > 0)
        #expect(endImage.width > 0)
    }

    @Test(arguments: shapes)
    func brushImagesUseDefaultScaleForZeroScale(shape: Shape) throws {
        let (startImage, endImage) = try BrushStampFactory.brushImages(for: shape, color: Self.red, scale: 0)

        #expect(startImage.height == Int(100 * BrushMask.defaultScale))
        #expect(endImage.height == Int(100 * BrushMask.defaultScale))
    }

    @Test func brushImagesRoundFractionalHeightsDown() throws {
        let shape = Shape(bottomLeft: CGPoint(x: 0, y: 33.5), bottomRight: CGPoint(x: 100, y: 33.5), topLeft: .zero, topRight: CGPoint(x: 100, y: 0))
        let (startImage, endImage) = try BrushStampFactory.brushImages(for: shape, color: Self.red, scale: 2)

        #expect(startImage.height == 66)
        #expect(endImage.height == 66)
    }

    @Test func brushImagesAreTintedWithColor() throws {
        let (startImage, endImage) = try BrushStampFactory.brushImages(for: Self.shapes[0], color: Self.red, scale: 2)

        for image in [startImage, endImage] {
            let pixels = try #require(Self.pixels(of: image))
            #expect(pixels.contains { $0.alpha > 128 })
            #expect(pixels.contains { $0.alpha == 0 })
            // Premultiplied, so a red pixel's red value matches its alpha, give or take rounding.
            #expect(pixels.allSatisfy { abs(Int($0.red) - Int($0.alpha)) <= 1 && $0.green == 0 && $0.blue == 0 })
        }
    }

    // MARK: Pixels

    private struct Pixel {
        let red: UInt8
        let green: UInt8
        let blue: UInt8
        let alpha: UInt8
    }

    /// The image's premultiplied RGBA pixels.
    private static func pixels(of image: CGImage) -> [Pixel]? {
        let width = image.width
        let height = image.height
        var bytes = [UInt8](repeating: 0, count: width * height * 4)

        let didDraw = bytes.withUnsafeMutableBytes { buffer -> Bool in
            guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB),
                  let context = CGContext(
                      data: buffer.baseAddress,
                      width: width,
                      height: height,
                      bitsPerComponent: 8,
                      bytesPerRow: width * 4,
                      space: colorSpace,
                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
                  )
            else { return false }

            context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
            return true
        }
        guard didDraw else { return nil }

        return stride(from: 0, to: bytes.count, by: 4).map { index in
            Pixel(red: bytes[index], green: bytes[index + 1], blue: bytes[index + 2], alpha: bytes[index + 3])
        }
    }
}
