//  Created by Geoff Pado on 4/22/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import ObservationsMac
public typealias HighlighterRecognizedText = ObservationsMac.RecognizedText
public typealias HighlighterRecognizedTextObservation = ObservationsMac.RecognizedTextObservation
#elseif canImport(UIKit)
import struct Observations.RecognizedText
import struct Observations.RecognizedTextObservation
import struct Observations.TextRectangleObservation
import struct Observations.WordObservation
import UIKit
public typealias HighlighterRecognizedText = RecognizedText
public typealias HighlighterRecognizedTextObservation = RecognizedTextObservation
#endif

import Vision

open class TextDetector: NSObject {
    #if canImport(AppKit) && !targetEnvironment(macCatalyst)
    public func detectText(in image: NSImage) async throws -> [TextRectangleObservation] {
        guard let detectionOperation = TextRectangleDetectionOperation(image: image) else {
            throw TextDetectorError.cannotCreateOperation
        }

        let imageSize = image.size

        return try await withCheckedThrowingContinuation { continuation in
            detectionOperation.completionBlock = { [weak detectionOperation] in
                guard let detectedTextObservations = detectionOperation?.textRectangleResults?
                    .map({ TextRectangleObservation($0, scaledTo: imageSize) })
                else { return continuation.resume(throwing: TextDetectorError.resultsMissing) }

                continuation.resume(returning: detectedTextObservations)
            }

            operationQueue.addOperation(detectionOperation)
        }
    }
    #elseif canImport(UIKit)
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
    #endif

    private func recognizeText(with operation: TextRecognitionOperation) async -> [HighlighterRecognizedText] {
        return await withCheckedContinuation { continuation in
            operation.completionBlock = { [weak operation] in
                // Detect all text in image.
                guard let operation = operation, let results = operation.recognizedTextResults else { return }

                let candidates = results.compactMap { result -> HighlighterRecognizedText? in
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

    private func recognizeTextObservations(with operation: TextRecognitionOperation) async -> [HighlighterRecognizedTextObservation] {
        await recognizeText(with: operation)
            .compactMap {
                RecognizedTextObservation($0, imageSize: operation.imageSize)
            }
    }

    private func recognizeWords(with operation: TextRecognitionOperation) async -> [WordObservation] {
        return await recognizeTextObservations(with: operation)
            .flatMap(\.allWordObservations)
    }

    #if canImport(AppKit) && !targetEnvironment(macCatalyst)
    @available(macOS 10.15, *)
    public func recognizeWords(in image: NSImage) async throws -> [WordObservation] {
        try await recognizeWords(with: TextRecognitionOperation(image: image))
    }

    public func detectText(in image: NSImage) async throws -> [HighlighterRecognizedTextObservation] {
        try await recognizeTextObservations(with: TextRecognitionOperation(image: image))
    }
    #elseif canImport(UIKit)
    public func recognizeWords(in image: UIImage) async throws -> [WordObservation] {
        try await recognizeWords(with: TextRecognitionOperation(image: image))
    }

    open func recognizeText(in image: UIImage) async throws -> [HighlighterRecognizedTextObservation] {
        try await recognizeTextObservations(with: TextRecognitionOperation(image: image))
    }
    #endif

    // MARK: Boilerplate

    private let operationQueue = OperationQueue()
}

public enum TextDetectorError: Error {
    case cannotCreateOperation
    case resultsMissing
}
