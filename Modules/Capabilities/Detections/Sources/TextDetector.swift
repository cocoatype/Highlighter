//  Created by Geoff Pado on 4/22/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit
import Vision

import struct Observations.RecognizedText
import struct Observations.RecognizedTextObservation
import struct Observations.TextRectangleObservation
import struct Observations.WordObservation

open class TextDetector: NSObject {
    open func detectText(in image: UIImage) async throws -> [TextRectangleObservation] {
        guard let detectionOperation = TextRectangleDetectionOperation(image: image) else {
            throw TextDetectorError.cannotCreateOperation
        }

        return try await withCheckedThrowingContinuation { continuation in
            detectionOperation.completionBlock = { [weak detectionOperation] in
                guard let detectedTextObservations = detectionOperation?.textRectangleResults?.map({ TextRectangleObservation($0, in: image) })
                else { return continuation.resume(throwing: TextDetectorError.resultsMissing) }

                continuation.resume(returning: detectedTextObservations)
            }

            operationQueue.addOperation(detectionOperation)
        }
    }

    private func recognizeText(with operation: TextRecognitionOperation) async -> [RecognizedText] {
        return await withCheckedContinuation { continuation in
            operation.completionBlock = { [weak operation] in
                // Detect all text in image.
                guard let operation = operation, let results = operation.recognizedTextResults else { return }

                let candidates = results.compactMap { result -> RecognizedText? in
                    // For every observation, get the top candidate.
                    guard let topCandidate = result.topCandidates(1).first else {
                        assertionFailure("had zero top candidates")
                        return nil
                    }
                    return RecognizedText(recognizedText: topCandidate, uuid: result.uuid)
                }

                continuation.resume(returning: candidates)
            }

            operationQueue.addOperation(operation)
        }
    }

    private func recognizeTextObservations(with operation: TextRecognitionOperation) async -> [RecognizedTextObservation] {
        await recognizeText(with: operation)
            .compactMap {
                RecognizedTextObservation($0, imageSize: operation.imageSize)
            }
    }

    private func recognizeWords(with operation: TextRecognitionOperation) async -> [WordObservation] {
        return await recognizeTextObservations(with: operation)
            .flatMap(\.allWordObservations)
    }

    public func recognizeWords(in image: UIImage) async throws -> [WordObservation] {
        try await recognizeWords(with: TextRecognitionOperation(image: image))
    }

    open func recognizeText(in image: UIImage) async throws -> [RecognizedTextObservation] {
        try await recognizeTextObservations(with: TextRecognitionOperation(image: image))
    }

    // MARK: Boilerplate

    private let operationQueue = OperationQueue()
}

public enum TextDetectorError: Error {
    case cannotCreateOperation
    case resultsMissing
}
