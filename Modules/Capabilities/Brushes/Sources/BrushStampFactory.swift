//  Created by Geoff Pado on 7/8/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import FactoryKit

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import ErrorHandlingMac
import GeometryMac

public enum BrushStampFactory {
    public static func brushImages(for shape: Shape, color: NSColor, scale: CGFloat) throws -> (CGImage, CGImage) {
        let height = shape.unionDotShapeDotShapeDotUnionCrash.geometryStreamer.height
        let startImage = try BrushStampFactory.brushStart(scaledToHeight: height, color: color)
        let endImage = try BrushStampFactory.brushEnd(scaledToHeight: height, color: color)

        return (startImage, endImage)
    }

    public static func brushStart(scaledToHeight height: CGFloat, color: NSColor) throws -> CGImage {
        guard let standardImage = Bundle.module.image(forResource: "Brush Start") else { Container.shared.errorHandler().crash("Unable to load brush start image") }
        return try scaledImage(from: standardImage, toHeight: height, color: color)
    }

    public static func brushEnd(scaledToHeight height: CGFloat, color: NSColor) throws -> CGImage {
        guard let standardImage = Bundle.module.image(forResource: "Brush End") else { Container.shared.errorHandler().crash("Unable to load brush end image") }
        return try scaledImage(from: standardImage, toHeight: height, color: color)
    }

    private static func scaledImage(from image: NSImage, toHeight height: CGFloat, color: NSColor) throws -> CGImage {
        let brushScale = height / image.size.height
        let scaledBrushSize = image.size * brushScale

        guard let imageRep = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(scaledBrushSize.width),
            pixelsHigh: Int(scaledBrushSize.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .deviceRGB,
            bytesPerRow: Int(scaledBrushSize.width) * 4,
            bitsPerPixel: 32
        ),
              let graphicsContext = NSGraphicsContext(bitmapImageRep: imageRep)
        else { throw BrushStampFactoryError.cannotCreateImageContext }
        NSGraphicsContext.current = graphicsContext
        let context = graphicsContext.cgContext
        context.setFillColor(color.cgColor)
        context.beginPath()
        context.addRect(CGRect(origin: .zero, size: scaledBrushSize))
        context.fillPath()
        context.scaleBy(x: brushScale, y: brushScale)

        image.draw(at: .zero, from: CGRect(origin: .zero, size: image.size), operation: .destinationIn, fraction: 1)
        guard let cgImage = context.makeImage() else { throw BrushStampFactoryError.cannotGenerateCGImage(color: color, height: height) }
        return cgImage
    }

    public static func brushStamp(scaledToHeight height: CGFloat, color: NSColor) throws -> CGImage {
        guard let stampImage = Bundle.module.image(forResource: "Brush") else { Container.shared.errorHandler().crash("Unable to load brush stamp image") }

        return try scaledImage(from: stampImage, toHeight: height, color: color)
    }
}

enum BrushStampFactoryError: Error {
    case cannotCreateImageContext
    case cannotGenerateCGImage(color: NSColor, height: CGFloat)
}
#elseif canImport(UIKit)
import ErrorHandling
import Geometry
import UIKit

public enum BrushStampFactory {
    public static func brushImages(for shape: Shape, color: UIColor, scale: CGFloat) throws -> (CGImage, CGImage) {
        let height = shape.unionDotShapeDotShapeDotUnionCrash.geometryStreamer.height
        let startImage = BrushStampFactory.brushStart(scaledToHeight: height, color: color)
        let endImage = BrushStampFactory.brushEnd(scaledToHeight: height, color: color)

        guard let startCGImage = startImage.cgImage(scale: scale),
              let endCGImage = endImage.cgImage(scale: scale)
        else {
            throw BrushStampFactoryError.cannotGenerateCGImage(
                shape: shape,
                color: color,
                scale: scale
            )
        }

        return (startCGImage, endCGImage)
    }

    private static func brushStart(scaledToHeight height: CGFloat, color: UIColor) -> UIImage {
        guard let startImage = UIImage(named: "Brush Start", in: .module, compatibleWith: nil)
        else { Container.shared.errorHandler().crash("Unable to load brush start image") }

        let brushScale = height / startImage.size.height
        let scaledBrushSize = (startImage.size * brushScale).integral

        return UIGraphicsImageRenderer(size: scaledBrushSize).image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: scaledBrushSize))

            let cgContext = context.cgContext
            cgContext.scaleBy(x: brushScale, y: brushScale)

            startImage.draw(at: .zero, blendMode: .destinationIn, alpha: 1)
        }
    }

    private static func brushEnd(scaledToHeight height: CGFloat, color: UIColor) -> UIImage {
        guard let endImage = UIImage(named: "Brush End", in: .module, compatibleWith: nil)
        else { Container.shared.errorHandler().crash("Unable to load brush end image") }

        let brushScale = height / endImage.size.height
        let scaledBrushSize = (endImage.size * brushScale).integral

        return UIGraphicsImageRenderer(size: scaledBrushSize).image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: scaledBrushSize))

            let cgContext = context.cgContext
            cgContext.scaleBy(x: brushScale, y: brushScale)

            endImage.draw(at: .zero, blendMode: .destinationIn, alpha: 1)
        }
    }

    public static func brushStamp(scaledToHeight height: CGFloat, color: UIColor) throws -> CGImage {
        guard let stampImage = UIImage(named: "Brush") else { Container.shared.errorHandler().crash("Unable to load brush stamp image") }

        let brushScale = height / stampImage.size.height
        let scaledBrushSize = stampImage.size * brushScale

        let scaledBrushImage = UIGraphicsImageRenderer(size: scaledBrushSize).image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: scaledBrushSize))

            let cgContext = context.cgContext
            cgContext.scaleBy(x: brushScale, y: brushScale)

            stampImage.draw(at: .zero, blendMode: .destinationIn, alpha: 1)
        }

        guard let scaledCGImage = scaledBrushImage.cgImage else {
            throw BrushStampFactoryError.cannotGenerateStampCGImage(color: color, scale: 1)
        }

        return scaledCGImage
    }
}

enum BrushStampFactoryError: Error {
    case cannotGenerateCGImage(shape: Shape, color: UIColor, scale: CGFloat)
    case cannotGenerateStampCGImage(color: UIColor, scale: CGFloat)
}
#endif
