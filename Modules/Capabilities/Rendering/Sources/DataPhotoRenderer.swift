//  Created by Geoff Pado on 7/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Brushes
import Geometry
import ImageIO
import Redactions
import UIKit

struct DataPhotoRenderer: PhotoRenderer {
    public init() {}

    public func render(
        image: UIImage,
        redactions: [Redaction]
    ) throws -> UIImage {
        guard let sourceImage = image.cgImage
        else { throw PhotoRenderError.noCGImage }

        let context = try createImageContext(
            size: sourceImage.size,
            scale: image.scale
        )
        defer { discardImageContext() }

        let cgImage = try render(
            sourceImage: sourceImage,
            redactions: redactions,
            context: context,
            orientation: image.imageOrientation.cgImageOrientation,
            flipped: true
        )
        return UIImage(cgImage: cgImage)
    }

    private func createImageContext(
        size: CGSize,
        scale: CGFloat
    ) throws -> CGContext {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let context = UIGraphicsGetCurrentContext()
        else { throw PhotoRenderError.noCurrentGraphicsContext }
        return context
    }

    private func discardImageContext() {
        UIGraphicsEndImageContext()
    }

    func render(
        imageSource: CGImageSource,
        redactions: [Redaction]
    ) throws -> CGImage {
        guard let sourceImage = imageSource.image
        else { throw PhotoRenderError.noCGImage }

        let context = try createImageContext(size: sourceImage.size, scale: 1)
        defer { discardImageContext() }

        return try render(
            sourceImage: sourceImage,
            redactions: redactions,
            context: context,
            orientation: imageSource.imageOrientation ?? .up,
            flipped: true
        )
    }

    #warning("#62: Simplify this method")
    // swiftlint:disable:next function_body_length
    private func render(
        sourceImage: CGImage,
        redactions: [Redaction],
        context: CGContext,
        orientation: CGImagePropertyOrientation,
        flipped: Bool
    ) throws -> CGImage {
        let imageSize = sourceImage.size
        var tileRect = CGRect.zero
        tileRect.size.width = imageSize.width
        tileRect.size.height = floor(CGFloat(Self.tileTotalPixels) / CGFloat(imageSize.width))

        let remainder = imageSize.height.truncatingRemainder(dividingBy: tileRect.height)
        let baseIterationCount = Int(imageSize.height / tileRect.height)
        let iterationCount = (remainder > 1) ? baseIterationCount + 1 : baseIterationCount

        let overlappingTileRect = CGRect(x: tileRect.minX, y: tileRect.minY, width: tileRect.width, height: tileRect.height + Self.seamOverlap)

        // draw tiles of source image
        context.saveGState()

        let translateTransform = CGAffineTransform(translationX: imageSize.width / 2, y: imageSize.height / 2)
        context.concatenate(translateTransform)

        let rotateTransform = CGAffineTransform(rotationAngle: orientation.rotationAngle)
        context.concatenate(rotateTransform)

        let untranslateTransform = CGAffineTransform(translationX: imageSize.width / -2, y: imageSize.height / -2)
        context.concatenate(untranslateTransform)

        if flipped {
            let flipTransform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: imageSize.height * -1)
            context.concatenate(flipTransform)
        }

        for y in 0..<iterationCount {
            try autoreleasepool {
                var currentTileRect = overlappingTileRect
                currentTileRect.origin.y = CGFloat(y) * (tileRect.size.height + Self.seamOverlap)

                if y == iterationCount - 1 && remainder > 0 {
                    let diffY = currentTileRect.maxY - imageSize.height
                    currentTileRect.size.height -= diffY
                }

                guard let imageRef = sourceImage.cropping(to: currentTileRect) else {
                    throw PhotoRenderError.noCGImage
                }

                context.draw(imageRef, in: currentTileRect)
            }
        }

        context.restoreGState()

        // draw redactions
        let drawings = redactions.flatMap { redaction -> [(part: RedactionPart, color: UIColor)] in
            return redaction.parts
                .map { (part: $0, color: redaction.color) }
        }

        try drawings.forEach { drawing in
            let (part, color) = drawing
            switch part {
            case .shape(let shape):
                let normalizedShape = shape.ggImage
                let (startImage, endImage) = try BrushStampFactory.brushImages(for: normalizedShape, color: color, scale: context.ctm.a)

                color.setFill()
                context.addPath(normalizedShape.path)
                context.fillPath()

                context.saveGState()
                context.translateBy(x: normalizedShape.topLeft.x, y: normalizedShape.topLeft.y)
                context.rotate(by: normalizedShape.angle)
                context.translateBy(x: -(startImage.size.width - 1), y: 0)
                context.draw(startImage, in: CGRect(origin: .zero, size: startImage.size))
                context.restoreGState()

                context.saveGState()
                context.translateBy(x: normalizedShape.topRight.x, y: normalizedShape.topRight.y)
                context.rotate(by: normalizedShape.angle)
                context.translateBy(x: -1, y: 0)
                context.draw(endImage, in: CGRect(origin: .zero, size: endImage.size))
                context.restoreGState()
            case .path(let path):
                let stampImage = try BrushStampFactory.brushStamp(scaledToHeight: path.lineWidth, color: color)
                let dashedPath = path.dashedPath
                dashedPath.forEachPoint { point in
                    context.saveGState()
                    defer { context.restoreGState() }

                    context.translateBy(x: stampImage.size.width * -0.5, y: stampImage.size.height * -0.5)
                    context.draw(stampImage, in: CGRect(origin: point, size: stampImage.size))
                }
            }
        }

        guard let image = context.makeImage() else { throw PhotoRenderError.noResultImage }
        return image
    }

    // MARK: Boilerplate

    private static let bytesPerMB = 1024 * 1024
    private static let bytesPerPixel = 4
    private static let pixelsPerMB = bytesPerMB / bytesPerPixel
    private static let seamOverlap = CGFloat(2)
    private static let sourceImageTileSizeMB = 120
    private static let tileTotalPixels = sourceImageTileSizeMB * pixelsPerMB
}
