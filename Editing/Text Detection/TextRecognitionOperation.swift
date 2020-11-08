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

@available(iOS 13.0, *)
class TextRecognitionOperation: Operation {
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

    init(url: URL) {
        self.imageRequestHandler = VNImageRequestHandler(url: url)
        super.init()
    }

    var recognizedTextResults: [VNRecognizedTextObservation]?

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
