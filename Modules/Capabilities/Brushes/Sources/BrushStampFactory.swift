//  Created by Geoff Pado on 7/8/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import CoreGraphics
import Foundation

import FactoryKit

import ErrorHandling
import Geometry

public enum BrushStampFactory {
    public static func brushImages(for shape: Shape, color: CGColor, scale: CGFloat) throws -> (CGImage, CGImage) {
        let height = shape.unionDotShapeDotShapeDotUnionCrash.geometryStreamer.height

        guard let startMask = BrushMask(named: "Brush Start", in: .module)
        else { Container.shared.errorHandler().crash("Unable to load brush start image") }

        guard let endMask = BrushMask(named: "Brush End", in: .module)
        else { Container.shared.errorHandler().crash("Unable to load brush end image") }

        guard let startImage = brushImage(from: startMask, scaledToHeight: height, color: color, scale: scale),
              let endImage = brushImage(from: endMask, scaledToHeight: height, color: color, scale: scale)
        else {
            throw BrushStampFactoryError.cannotGenerateCGImage(
                shape: shape,
                color: color,
                scale: scale
            )
        }

        return (startImage, endImage)
    }

    public static func brushStamp(scaledToHeight height: CGFloat, color: CGColor) throws -> CGImage {
        guard let stampMask = BrushMask(named: "Brush", in: .main)
        else { Container.shared.errorHandler().crash("Unable to load brush stamp image") }

        guard let stampImage = tintedImage(from: stampMask, scaledToHeight: height, color: color, scale: BrushMask.defaultScale, roundsSizeDown: false)
        else { throw BrushStampFactoryError.cannotGenerateStampCGImage(color: color, scale: 1) }

        return stampImage
    }

    /// Makes a brush start or end image at `scale`, or at the default scale if `scale` is 0.
    ///
    /// The image is drawn at the default scale first and then resampled to `scale`, which matches how these images
    /// were rendered with `UIGraphicsImageRenderer`.
    private static func brushImage(from mask: BrushMask, scaledToHeight height: CGFloat, color: CGColor, scale: CGFloat) -> CGImage? {
        let defaultScale = BrushMask.defaultScale
        guard let image = tintedImage(from: mask, scaledToHeight: height, color: color, scale: defaultScale, roundsSizeDown: true)
        else { return nil }

        guard scale > 0, abs(scale - defaultScale) >= 0.01 else { return image }

        return resampled(image, from: defaultScale, to: scale)
    }

    private static func resampled(_ image: CGImage, from sourceScale: CGFloat, to scale: CGFloat) -> CGImage? {
        let size = image.size * (1 / sourceScale)
        guard let context = topLeftContext(size: size, scale: scale) else { return nil }

        context.drawUpright(image, in: CGRect(origin: .zero, size: size))
        return context.makeImage()
    }

    /// Makes an image filled with `color`, scaled to `height` points, using `mask`'s alpha.
    ///
    /// - Parameter roundsSizeDown: Whether to round the image's size down to whole points. The mask is still drawn at
    ///   its full scaled size, aligned to the top edge, so any fractional part is cropped off the bottom.
    static func tintedImage(
        from mask: BrushMask,
        scaledToHeight height: CGFloat,
        color: CGColor,
        scale: CGFloat,
        roundsSizeDown: Bool
    ) -> CGImage? {
        let brushScale = height / mask.size.height
        let maskSize = mask.size * brushScale
        let imageSize = roundsSizeDown ? maskSize.integral : maskSize

        guard let context = topLeftContext(size: imageSize, scale: scale) else { return nil }

        context.setFillColor(color)
        context.fill(CGRect(origin: .zero, size: imageSize))

        context.setBlendMode(.destinationIn)
        context.drawUpright(mask.image, in: CGRect(origin: .zero, size: maskSize))

        return context.makeImage()
    }

    /// A bitmap context of `size` points at `scale`, with its origin at the top left, like `UIGraphicsImageRenderer`.
    ///
    /// When the size in pixels isn't whole, the context is rounded up, leaving the extra space at the bottom.
    private static func topLeftContext(size: CGSize, scale: CGFloat) -> CGContext? {
        let pixelWidth = Int((size.width * scale).rounded(.up))
        let pixelHeight = Int((size.height * scale).rounded(.up))

        guard pixelWidth > 0,
              pixelHeight > 0,
              let colorSpace = CGColorSpace(name: CGColorSpace.sRGB),
              let context = CGContext(
                  data: nil,
                  width: pixelWidth,
                  height: pixelHeight,
                  bitsPerComponent: 8,
                  bytesPerRow: 0,
                  space: colorSpace,
                  bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
              )
        else { return nil }

        context.translateBy(x: 0, y: CGFloat(pixelHeight))
        context.scaleBy(x: scale, y: -scale)
        return context
    }
}

private extension CGContext {
    /// Draws `image` right side up in a context whose origin is at the top left.
    func drawUpright(_ image: CGImage, in rect: CGRect) {
        saveGState()
        defer { restoreGState() }

        translateBy(x: 0, y: rect.minY + rect.maxY)
        scaleBy(x: 1, y: -1)
        draw(image, in: rect)
    }
}

enum BrushStampFactoryError: Error {
    case cannotGenerateCGImage(shape: Shape, color: CGColor, scale: CGFloat)
    case cannotGenerateStampCGImage(color: CGColor, scale: CGFloat)
}
