//  Created by Geoff Pado on 4/22/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import OSLog
import UIKit
import Vision

import FactoryKit

import ErrorHandling

class TextRectangleDetectionOperation: Operation, @unchecked Sendable {
    init?(image: UIImage) {
        guard let cgImage = image.cgImage else { return nil }
        self.imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: image.imageOrientation.cgImagePropertyOrientation)

        super.init()
    }

    var textRectangleResults: [VNTextObservation]?

    override func start() {
        let imageRequest = VNDetectTextRectanglesRequest { [weak self] request, error in
            guard let textObservations = (request.results as? [VNTextObservation]) else {
                if let error {
                    self?.errorHandler.log(
                        error,
                        module: "Detections",
                        type: "TextRectangleDetectionOperation"
                    )
                }
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
            errorHandler.log(
                error,
                module: "Detections",
                type: "TextRectangleDetectionOperation"
            )
            _finished = true
            _executing = false
        }
    }

    // MARK: Logging

    @Injected(\.errorHandler) private var errorHandler

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
