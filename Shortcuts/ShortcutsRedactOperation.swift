//  Created by Geoff Pado on 11/4/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Editing
import Intents
import UIKit
import UniformTypeIdentifiers

class ShortcutsRedactOperation: Operation {
    var result: Result<INFile, Error>?
    init(input: INFile, wordList: [String]) {
        self.input = input
        self.wordList = wordList
    }

    override func start() {
//        guard let image = UIImage(data: input.data) else { return fail(with: ShortcutsRedactOperationError.noImage) }
        let input = self.input
        let wordList = self.wordList
        detector.detectWords(inImageAt: input.fileURL!) { [weak self] detectedObservations in
            let observations = detectedObservations ?? []
            let matchingObservations = observations.filter { observation in
                wordList.contains(where: { wordListString in
                    wordListString.compare(observation.string, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
                })
            }

            let redactions = matchingObservations.map { TextObservationRedaction($0, color: .black) }

            ShortcutsRedactExporter.export(input, redactions: redactions) { [weak self] result in
                self?.finish(with: result)
            }
        }
    }

    private func finish(with result: Result<INFile, Error>) {
        self.result = result
        _finished = true
        _executing = false
    }

    private func fail(with error: Error) {
        finish(with: .failure(error))
    }

    // MARK: Boilerplate

    private let detector = TextRectangleDetector()
    private let input: INFile
    private let wordList: [String]

    override var isAsynchronous: Bool { return true }

    private var _executing = false {
        willSet {
            willChangeValue(for: \.isExecuting)
        }

        didSet {
            didChangeValue(for: \.isExecuting)
        }
    }
    override var isExecuting: Bool { return _executing }

    private var _finished = false {
        willSet {
            willChangeValue(for: \.isFinished)
        }

        didSet {
            didChangeValue(for: \.isFinished)
        }
    }
    override var isFinished: Bool { return _finished }
}

enum ShortcutsRedactOperationError: Error {
    case noImage
}

class ShortcutsRedactExporter: NSObject {
    static func export(_ input: INFile, redactions: [Redaction], completionHandler: @escaping((Result<INFile, Error>) -> Void)) {
        let exportOperation = ShortcutsExportOperation(input: input, redactions: redactions)
        let callbackOperation = BlockOperation {
            guard let result = exportOperation.result else {
                return completionHandler(.failure(ShortcutsExportError.operationReturnedNoResult))
            }

            completionHandler(result)
        }

        callbackOperation.addDependency(exportOperation)
        operationQueue.addOperations([exportOperation, callbackOperation], waitUntilFinished: false)
    }

    private static let operationQueue = OperationQueue()
}

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

enum ShortcutsExportError: Error {
    case failedToGenerateGraphicsContext
    case failedToRenderImage
    case noImageForInput
    case operationReturnedNoResult
    case writeError
}
