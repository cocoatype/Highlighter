//  Created by Geoff Pado on 4/22/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import os.log
import Vision

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

class TextRectangleDetectionOperation: Operation {
    #if canImport(UIKit)
    init?(image: UIImage) {
        guard let cgImage = image.cgImage else { return nil }
        self.imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: image.imageOrientation.cgImagePropertyOrientation)

        super.init()
    }
    #elseif canImport(AppKit)
    init?(image: NSImage) {
        var imageRect = NSRect(origin: .zero, size: image.size)
        guard let cgImage = image.cgImage(forProposedRect: &imageRect, context: nil, hints: nil) else { return nil }

        self.imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: .up)
    }
    #endif

    var textRectangleResults: [VNTextObservation]?

    override func start() {
        let imageRequest = VNDetectTextRectanglesRequest { [weak self] request, error in
            guard let textObservations = (request.results as? [VNTextObservation]) else {
                TextRectangleDetectionOperation.log("error getting text rectangles: \(error?.localizedDescription ?? "(null)")", type: .error)
                self?._finished = true
                self?._executing = false
                return
            }

            self?.textRectangleResults = textObservations
            self?._finished = true
            self?._executing = false
        }
        imageRequest.reportCharacterBoxes = true

        do {
            try imageRequestHandler.perform([imageRequest])
            _executing = true
        } catch {
            TextRectangleDetectionOperation.log("error starting image request: \(error.localizedDescription)", type: .error)
            _finished = true
            _executing = false
        }
    }

    // MARK: Logging

    static var log: OSLog { return OSLog(subsystem: "com.cocoatype.Highlighter", category: "Text Detection") }
    static func log(_ text: String, type: OSLogType = .default) {
        os_log("%@", log: TextRectangleDetectionOperation.log, type: type, text)
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
