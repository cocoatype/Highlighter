//  Created by Geoff Pado on 7/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import UIKit

public actor PhotoExportRenderer {
    public init(image: UIImage, redactions: [Redaction]) {
        self.redactions = redactions
        self.sourceImage = image
    }

    public func render() -> UIImage {
        let imageSize = sourceImage.size * sourceImage.scale

        var tileRect = CGRect.zero
        tileRect.size.width = imageSize.width
        tileRect.size.height = floor(CGFloat(Self.tileTotalPixels) / CGFloat(imageSize.width))

        NSLog("source tile size: %f x %f", tileRect.width, tileRect.height)

        let remainder = imageSize.height.truncatingRemainder(dividingBy: tileRect.height)
        let baseIterationCount = Int(imageSize.height / tileRect.height)
        let iterationCount = (remainder > 1) ? baseIterationCount + 1 : baseIterationCount

        let overlappingTileRect = CGRect(x: tileRect.minX, y: tileRect.minY, width: tileRect.width, height: tileRect.height + Self.seamOverlap)

        let imageRenderer = UIGraphicsImageRenderer(size: imageSize)
        return imageRenderer.image { rendererContext in
            let context = rendererContext.cgContext

            // draw tiles of source image
            context.saveGState()

            let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: imageSize.height * -1)
            context.concatenate(transform)

            for y in 0..<iterationCount {
                autoreleasepool {
                    NSLog("iteration %d of %d", y, iterationCount)
                    var currentTileRect = overlappingTileRect
                    currentTileRect.origin.y = CGFloat(y) * (tileRect.size.height + Self.seamOverlap)

                    if (y == iterationCount - 1 && remainder > 0) {
                        let diffY = currentTileRect.maxY - imageSize.height
                        currentTileRect.size.height -= diffY
                    }

                    if let imageRef = sourceImage.cgImage?.cropping(to: currentTileRect) {
                        context.draw(imageRef, in: currentTileRect)
                    }
                }
            }

            context.restoreGState()

            // draw redactions
            let drawings = redactions.flatMap { redaction -> [(path: UIBezierPath, color: UIColor)] in
                return redaction.paths
                  .map { (path: $0, color: redaction.color) }
            }

            drawings.forEach { drawing in
                let (path, color) = drawing
                let borderBounds = path.strokeBorderPath.bounds
                if path.isRect {
                    let startImage = BrushStampFactory.brushStart(scaledToHeight: borderBounds.height, color: color)
                    let endImage = BrushStampFactory.brushEnd(scaledToHeight: borderBounds.height, color: color)

                    color.setFill()
                    UIBezierPath(rect: borderBounds).fill()

                    let startRect = CGRect(origin: borderBounds.origin, size: startImage.size).offsetBy(dx: -startImage.size.width, dy: 0)
                    context.draw(startImage.cgImage!, in: startRect)

                    let endRect = CGRect(origin: borderBounds.origin, size: endImage.size).offsetBy(dx: borderBounds.width, dy: 0)
                    context.draw(endImage.cgImage!, in: endRect)
                } else {
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
        }
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
