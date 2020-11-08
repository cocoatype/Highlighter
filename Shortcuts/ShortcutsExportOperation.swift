//  Created by Geoff Pado on 11/6/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Editing
import Intents
import UniformTypeIdentifiers

@available(iOS 14.0, *)
class ShortcutsExportOperation: Operation {
    var result: Result<INFile, Error>?

    init(input: INFile, redactions: [Redaction]) {
        self.input = input
        self.redactions = redactions
    }

    override func main() {
        guard let sourceImage = UIImage(data: input.data) else {
            result = .failure(ShortcutsExportError.noImageForInput)
            return
        }
        let imageSize = sourceImage.size * sourceImage.scale

        UIGraphicsBeginImageContextWithOptions(imageSize, true, 1)
        let context = UIGraphicsGetCurrentContext()
        defer { UIGraphicsEndImageContext() }

        var tileRect = CGRect.zero
        tileRect.size.width = imageSize.width
        tileRect.size.height = floor(CGFloat(Self.tileTotalPixels) / CGFloat(imageSize.width))

        NSLog("source tile size: %f x %f", tileRect.width, tileRect.height)

        let remainder = imageSize.height.truncatingRemainder(dividingBy: tileRect.height)
        let baseIterationCount = Int(imageSize.height / tileRect.height)
        let iterationCount = (remainder > 1) ? baseIterationCount + 1 : baseIterationCount

        let overlappingTileRect = CGRect(x: tileRect.minX, y: tileRect.minY, width: tileRect.width, height: tileRect.height + Self.seamOverlap)

        // draw tiles of source image
        context?.saveGState()

        let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: imageSize.height * -1)
        context?.concatenate(transform)

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
                    context?.draw(imageRef, in: currentTileRect)
                }
            }
        }

        context?.restoreGState()

        // draw redactions
        let drawings = redactions.flatMap { redaction -> [(path: UIBezierPath, color: UIColor)] in
            return redaction.paths
              .map(\.dashedPath)
              .map { (path: $0, color: redaction.color) }
        }

        drawings.forEach { drawing in
            let (path, color) = drawing
            let stampImage = BrushStampFactory.brushStamp(scaledToHeight: path.lineWidth, color: color)
            path.forEachPoint { point in
                guard let context = context else { return }
                context.saveGState()
                defer { context.restoreGState() }

                context.translateBy(x: stampImage.size.width * -0.5, y: stampImage.size.height * -0.5)
                stampImage.draw(at: point)
            }
        }

        // return result
        guard let imageData = UIGraphicsGetImageFromCurrentImageContext()?.pngData() else {
            result = .failure(ShortcutsExportError.failedToRenderImage)
            return
        }

        let filename = ((input.filename as NSString).deletingPathExtension as NSString).appendingPathExtension(for: UTType.png)
        result = .success(INFile(data: imageData, filename: filename, typeIdentifier: UTType.png.identifier))
    }

    // MARK: Boilerplate

    private static let bytesPerMB = 1024 * 1024
    private static let bytesPerPixel = 4
    private static let pixelsPerMB = bytesPerMB / bytesPerPixel
    private static let seamOverlap = CGFloat(2)
    private static let sourceImageTileSizeMB = 120
    private static let tileTotalPixels = sourceImageTileSizeMB * pixelsPerMB

    private let input: INFile
    private let redactions: [Redaction]
}

@available(iOS 14.0, *)
enum ShortcutsExportError: Error {
    case failedToGenerateGraphicsContext
    case failedToRenderImage
    case noImageForInput
    case operationReturnedNoResult
    case writeError
}
