//  Created by Geoff Pado on 7/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import UIKit

public actor PhotoExportRenderer {
    public init(image: UIImage, redactions: [Redaction]) {
        self.redactions = redactions
        self.sourceImage = image
    }

    public func render() throws -> UIImage {
        let imageSize = sourceImage.realSize * sourceImage.scale

        var tileRect = CGRect.zero
        tileRect.size.width = imageSize.width
        tileRect.size.height = floor(CGFloat(Self.tileTotalPixels) / CGFloat(imageSize.width))

        NSLog("source tile size: %f x %f", tileRect.width, tileRect.height)

        let remainder = imageSize.height.truncatingRemainder(dividingBy: tileRect.height)
        let baseIterationCount = Int(imageSize.height / tileRect.height)
        let iterationCount = (remainder > 1) ? baseIterationCount + 1 : baseIterationCount

        let overlappingTileRect = CGRect(x: tileRect.minX, y: tileRect.minY, width: tileRect.width, height: tileRect.height + Self.seamOverlap)

        UIGraphicsBeginImageContextWithOptions(sourceImage.size, false, sourceImage.scale)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { throw PhotoExportRenderError.noCurrentGraphicsContext }

        // draw tiles of source image
        context.saveGState()

        let translateTransform = CGAffineTransform(translationX: sourceImage.size.width / 2, y: sourceImage.size.height / 2)
        context.concatenate(translateTransform)

        let rotateTransform = CGAffineTransform(rotationAngle: sourceImage.imageOrientation.rotationAngle)
        context.concatenate(rotateTransform)

        let untranslateTransform = CGAffineTransform(translationX: sourceImage.realSize.width / -2, y: sourceImage.realSize.height / -2)
        context.concatenate(untranslateTransform)

        let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: imageSize.height * -1)
        context.concatenate(transform)

        for y in 0..<iterationCount {
            try autoreleasepool {
                NSLog("iteration %d of %d", y, iterationCount)
                var currentTileRect = overlappingTileRect
                currentTileRect.origin.y = CGFloat(y) * (tileRect.size.height + Self.seamOverlap)

                if (y == iterationCount - 1 && remainder > 0) {
                    let diffY = currentTileRect.maxY - imageSize.height
                    currentTileRect.size.height -= diffY
                }

                guard let imageRef = sourceImage.cgImage?.cropping(to: currentTileRect) else {
                    throw PhotoExportRenderError.noCGImage
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
                let (startImage, endImage) = try BrushStampFactory.brushImages(for: shape, color: color, scale: 1)

                color.setFill()
                UIBezierPath(cgPath: shape.path).fill()

                context.saveGState()
                context.translateBy(x: shape.topLeft.x, y: shape.topLeft.y)
                context.rotate(by: shape.angle)
                context.translateBy(x: -startImage.size.width, y: 0)
                context.draw(startImage, in: CGRect(origin: .zero, size: startImage.size))
                context.restoreGState()

                context.saveGState()
                context.translateBy(x: shape.topRight.x, y: shape.topRight.y)
                context.rotate(by: shape.angle)
                context.draw(endImage, in: CGRect(origin: .zero, size: endImage.size))
                context.restoreGState()
            case .path(let path):
                let stampImage = BrushStampFactory.brushStamp(scaledToHeight: path.lineWidth, color: color)
                let dashedPath = path.dashedPath
                dashedPath.forEachPoint { point in
                    context.saveGState()
                    defer { context.restoreGState() }

                    context.translateBy(x: stampImage.size.width * -0.5, y: stampImage.size.height * -0.5)
                    stampImage.draw(at: point)
                }
            }
        }

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { throw PhotoExportRenderError.noResultImage }
        return image
    }

    // MARK: Boilerplate

    private static let bytesPerMB = 1024 * 1024
    private static let bytesPerPixel = 4
    private static let pixelsPerMB = bytesPerMB / bytesPerPixel
    private static let seamOverlap = CGFloat(2)
    private static let sourceImageTileSizeMB = 120
    private static let tileTotalPixels = sourceImageTileSizeMB * pixelsPerMB

    private let redactions: [Redaction]
    private let sourceImage: UIImage
}

public enum PhotoExportRenderError: Error {
    case noCurrentGraphicsContext
    case noCGImage
    case noResultImage
}
