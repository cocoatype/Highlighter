//  Created by Geoff Pado on 7/29/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation
import os.log
import Vision

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

class TextRecognitionOperation: Operation {
    #if canImport(UIKit)
    init(image: UIImage) throws {
        guard let cgImage = image.cgImage else { throw TextRecognitionOperationError.cannotCreateCGImageFromImage }
        self.imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: image.imageOrientation.cgImagePropertyOrientation)
        self.imageSize = CGSize(width: cgImage.width, height: cgImage.height)

        super.init()
    }
    #elseif canImport(AppKit)
    init(image: NSImage) throws {
        var imageRect = NSRect(origin: .zero, size: image.size)
        guard let cgImage = image.cgImage(forProposedRect: &imageRect, context: nil, hints: nil) else { throw TextRecognitionOperationError.cannotCreateCGImageFromImage }

        self.imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: .up)
        self.imageSize = CGSize(width: cgImage.width, height: cgImage.height)
    }
    #endif

    var recognizedTextResults: [VNRecognizedTextObservation]?
    let imageSize: CGSize

    override func start() {
        os_log("running recognition")
        let imageRequest = VNRecognizeTextRequest { [weak self] request, error in
            guard let textObservations = (request.results as? [VNRecognizedTextObservation]) else {
                TextRectangleDetectionOperation.log("error getting text rectangles: \(error?.localizedDescription ?? "(null)")", type: .error)
                self?._finished = true
                self?._executing = false
                return
            }

            self?.recognizedTextResults = textObservations
            self?._finished = true
            self?._executing = false
        }
        imageRequest.recognitionLevel = .accurate
        imageRequest.usesLanguageCorrection = true

        do {
            try imageRequestHandler.perform([imageRequest])
            _executing = true
        } catch {
            TextRecognitionOperation.log("error starting image request: \(error.localizedDescription)", type: .error)
            _finished = true
            _executing = false
        }
    }

    // MARK: Logging

    static var log: OSLog { return OSLog(subsystem: "com.cocoatype.Highlighter", category: "Text Detection") }
    static func log(_ text: String, type: OSLogType = .default) {
        os_log("%@", log: TextRecognitionOperation.log, type: type, text)
    }

    // MARK: Boilerplate

    private let imageRequestHandler: VNImageRequestHandler

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

public enum TextRecognitionOperationError: Error {
    case cannotCreateCGImageFromImage
}
