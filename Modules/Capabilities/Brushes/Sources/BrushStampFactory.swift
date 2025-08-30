//  Created by Geoff Pado on 7/8/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import FactoryKit

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
