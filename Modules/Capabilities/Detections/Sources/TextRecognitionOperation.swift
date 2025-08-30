//  Created by Geoff Pado on 7/29/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation
import OSLog
import UIKit
import Vision

import FactoryKit

import ErrorHandling

class TextRecognitionOperation: Operation, @unchecked Sendable {
    init(image: UIImage) throws {
        guard let cgImage = image.cgImage else { throw TextRecognitionOperationError.cannotCreateCGImageFromImage }
        self.imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: image.imageOrientation.cgImagePropertyOrientation)
        self.imageSize = CGSize(width: cgImage.width, height: cgImage.height)

        super.init()
    }

    var recognizedTextResults: [VNRecognizedTextObservation]?
    let imageSize: CGSize

    override func start() {
        os_log("running recognition")
        let imageRequest = VNRecognizeTextRequest { [weak self] request, error in
            guard let textObservations = (request.results as? [VNRecognizedTextObservation]) else {
                if let error {
                    self?.errorHandler.log(error, module: "Detections", type: "TextRecognitionOperation")
                }

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
            errorHandler.log(error, module: "Detections", type: "TextRecognitionOperation")
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

public enum TextRecognitionOperationError: Error {
    case cannotCreateCGImageFromImage
}
