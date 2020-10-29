//  Created by Geoff Pado on 10/26/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import AppKit
import Automator
import Redacting
import os.log
import UniformTypeIdentifiers

class RedactAction: AMBundleAction {
    override func runAsynchronously(withInput input: Any?) {
        guard let inputArray = input as? [Any] else { return finish(with: ActionError.unknownInput, originalInput: input) }

        let inputItems = inputArray.compactMap { inputItem -> Input? in
            switch inputItem {
            case let string as String:
                return Input.string(string)
            case let url as URL:
                return Input.url(url)
            case let data as Data:
                return Input.data(data)
            default: return nil
            }
        }

        let images = inputItems.compactMap { $0.image }
        let firstImage = images[0]

        detector.detectWords(in: firstImage) { [weak self] observations in
            guard let observations = observations else { return self?.finishRunningWithError(nil) ?? () }
            let matchingObservations = observations.filter { $0.string == "Highlighter" }

            let finalImage = NSImage(size: firstImage.size, flipped: false) { rect -> Bool in
                var rect = rect
                guard let context = NSGraphicsContext.current?.cgContext else { return false }

                if let cgImage = firstImage.cgImage(forProposedRect: &rect, context: nil, hints: nil) {
                    context.draw(cgImage, in: rect)
                }

                let rects = matchingObservations.map(\.bounds)
                context.setFillColor(NSColor.systemRed.cgColor)
                context.fill(rects)
                return true
            }

            self?.finish(with: finalImage, for: inputItems[0])
        }
    }

    private func finish(with error: Error, originalInput: Any?) {
        output = originalInput
        finishRunningWithError(error)
    }

    private func finish(with image: NSImage, for input: Input) {
        operationQueue.addOperation { [weak self] in
            do {
                let writeURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString).appendingPathExtension(input.fileType?.preferredFilenameExtension ?? "png")

                guard let imageRep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(image.size.width), pixelsHigh: Int(image.size.height), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: Int(image.size.width) * 4, bitsPerPixel: 32) else { throw ActionError.writeError }

                let context = NSGraphicsContext(bitmapImageRep: imageRep)
                NSGraphicsContext.saveGraphicsState()
                NSGraphicsContext.current = context
                image.draw(at: .zero, from: CGRect(origin: .zero, size: image.size), operation: .copy, fraction: 1)
                NSGraphicsContext.restoreGraphicsState()

                guard let data = imageRep.representation(using: input.imageType, properties: [:]) else { throw ActionError.writeError }
                try data.write(to: writeURL)

                self?.output = writeURL.path
                self?.finishRunningWithError(nil)
            } catch {
                self?.finishRunningWithError(error)
            }
        }
    }

    private let detector = TextRectangleDetector()
    private let operationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .userInitiated
        return operationQueue
    }()
}

enum Input {
    case string(String),
         url(URL),
         data(Data)

    var fileType: UTType? {
        let fileURL: URL
        switch self {
        case .string(let string): fileURL = URL(fileURLWithPath: string)
        case .url(let url): fileURL = url
        default: return nil
        }

        do {
            let resourceValues = try fileURL.resourceValues(forKeys: [.contentTypeKey])
            return resourceValues.contentType
        } catch { return nil }
    }

    var imageType: NSBitmapImageRep.FileType {
        switch fileType {
        case UTType.tiff: return .tiff
        case UTType.bmp: return .bmp
        case UTType.gif: return .gif
        case UTType.jpeg: return .jpeg
        case UTType.png: return .png
        default: return .png
        }
    }

    var image: NSImage? {
        switch self {
        case .string(let string): return NSImage(contentsOfFile: string)
        case .url(let url): return NSImage(contentsOf: url)
        case .data(let data): return NSImage(data: data)
        }
    }
}

enum ActionError: Error {
    case writeError
    case unknownInput
}
