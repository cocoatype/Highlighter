//  Created by Geoff Pado on 4/22/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation
import Vision

import struct Observations.RecognizedText
import struct Observations.RecognizedTextObservation
import struct Observations.TextRectangleObservation
import struct Observations.WordObservation

public final class TextDetector: NSObject, Sendable {
    public func detectText(in image: DetectableImage) async throws -> [TextRectangleObservation] {
        let detectionOperation = TextRectangleDetectionOperation(image: image)
        let imageSize = image.orientedSize

        return try await withCheckedThrowingContinuation { continuation in
            detectionOperation.completionBlock = { [weak detectionOperation] in
                guard let detectedTextObservations = detectionOperation?.textRectangleResults?.map({ TextRectangleObservation($0, scaledTo: imageSize) })
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

    public func recognizeWords(in image: DetectableImage) async throws -> [WordObservation] {
        await recognizeWords(with: TextRecognitionOperation(image: image))
    }

    public func recognizeText(in image: DetectableImage) async throws -> [RecognizedTextObservation] {
        await recognizeTextObservations(with: TextRecognitionOperation(image: image))
    }

    // MARK: Boilerplate

    private let operationQueue = OperationQueue()
}

public enum TextDetectorError: Error {
    case resultsMissing
}
