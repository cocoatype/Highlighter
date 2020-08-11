//  Created by Geoff Pado on 7/29/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation
import os.log
import Vision

@available(iOS 13.0, *)
class TextRecognitionOperation: Operation {
    init?(image: UIImage) {
        guard let cgImage = image.cgImage else { return nil }
        self.imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: image.imageOrientation.cgImagePropertyOrientation)

        super.init()
    }

    var recognizedTextResults: [VNRecognizedTextObservation]?

    override func start() {
        #if targetEnvironment(macCatalyst)
        _finished = true
        _executing = false
        #else
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
        #endif
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
