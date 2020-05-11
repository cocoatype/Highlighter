//  Created by Geoff Pado on 5/13/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PhotoExporter: NSObject {

    static func export(_ image: UIImage, redactions: [Redaction], completionHandler: @escaping ((Result<UIImage, Error>) -> Void)) {
        let exportOperation = PhotoExportOperation(image: image, redactions: redactions)
        let callbackOperation = BlockOperation {
            guard let result = exportOperation.result else {
                return completionHandler(.failure(PhotoExportError.operationReturnedNoResult))
            }

            completionHandler(result)
        }
        callbackOperation.addDependency(exportOperation)

        operationQueue.addOperations([exportOperation, callbackOperation], waitUntilFinished: false)
    }

//    var exportedImage: UIImage? {
//        let imageBounds = imageView.bounds
//        UIGraphicsBeginImageContextWithOptions(imageBounds.size, true, 1)
//        defer { UIGraphicsEndImageContext() }
//
//        imageView.drawHierarchy(in: imageBounds, afterScreenUpdates: true)
//        redactionView.drawHierarchy(in: imageBounds, afterScreenUpdates: true)
//
//        return UIGraphicsGetImageFromCurrentImageContext()
//    }

    // MARK: Boilerplate

    private static let operationQueue = OperationQueue()
}

enum PhotoExportError: Error {
    case imageGenerationFailed
    case operationReturnedNoResult
}

class PhotoExportOperation: Operation {
    var result: Result<UIImage, Error>?

    init(image: UIImage, redactions: [Redaction]) {
        self.redactions = redactions
        self.sourceImage = image
    }

    override func main() {
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
        let paths = redactions
          .flatMap { $0.paths }
          .map { $0.dashedPath }

        paths.forEach { path in
            let stampImage = brushStamp(scaledToHeight: path.lineWidth)
            path.forEachPoint { point in
                guard let context = context else { return }
                context.saveGState()
                defer { context.restoreGState() }

                context.translateBy(x: stampImage.size.width * -0.5, y: stampImage.size.height * -0.5)
                stampImage.draw(at: point)
            }
        }

        // return result
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            result = .success(image)
        } else {
            result = .failure(NSError(domain: "unknown", code: 0, userInfo: nil))
        }
    }

    // MARK: Brush Stamp

    private func brushStamp(scaledToHeight height: CGFloat) -> UIImage {
        guard let standardImage = UIImage(named: "Brush") else { fatalError("Unable to load brush stamp image") }

        let brushScale = height / standardImage.size.height
        let scaledBrushSize = standardImage.size * brushScale

        UIGraphicsBeginImageContext(scaledBrushSize)
        defer { UIGraphicsEndImageContext() }

        guard let context = UIGraphicsGetCurrentContext() else { fatalError("Unable to create brush scaling image context") }
        context.scaleBy(x: brushScale, y: brushScale)

        standardImage.draw(at: .zero)

        guard let scaledImage = UIGraphicsGetImageFromCurrentImageContext() else { fatalError("Unable to get scaled brush image from context") }
        return scaledImage
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
