//  Created by Geoff Pado on 4/22/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Vision

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public class TextRectangleDetector: NSObject {
    #if canImport(UIKit)
    public func detectTextRectangles(in image: UIImage, completionHandler: (([TextRectangleObservation]?) -> Void)? = nil) {
        guard let detectionOperation = TextRectangleDetectionOperation(image: image) else {
            completionHandler?(nil)
            return
        }

        detectionOperation.completionBlock = { [weak detectionOperation] in
            let detectedTextObservations = detectionOperation?.textRectangleResults?.map { TextRectangleObservation($0, in: image) }
            completionHandler?(detectedTextObservations)
        }

        operationQueue.addOperation(detectionOperation)
    }
    #elseif canImport(AppKit)
    public func detectTextRectangles(in image: NSImage, completionHandler: (([TextRectangleObservation]?) -> Void)? = nil) {
        guard let detectionOperation = TextRectangleDetectionOperation(image: image) else {
            completionHandler?(nil)
            return
        }

        detectionOperation.completionBlock = { [weak detectionOperation] in
            let detectedTextObservations = detectionOperation?.textRectangleResults?.map { TextRectangleObservation($0, in: image) }
            completionHandler?(detectedTextObservations)
        }

        operationQueue.addOperation(detectionOperation)
    }

    #endif

    #if canImport(UIKit)
    @available(iOS 13.0, *)
    public func detectWords(in image: UIImage, completionHandler: @escaping (([WordObservation]?) -> Void)) {
        if let recognitionOperation = TextRecognitionOperation(image: image) {
            recognitionOperation.completionBlock = { [weak recognitionOperation] in
                // Detect all text in image.
                guard let results = recognitionOperation?.recognizedTextResults else { return }

                // For every observation, get the top candidate.
                let candidates = results.compactMap { $0.topCandidates(1).first }

                // Flatten together every struct.
                let observations = candidates.flatMap { candidate -> [WordObservation] in
                    // Take the top candidate's string and split it on word boundaries.
                    let words = candidate.string.words
                    return words.compactMap { word -> WordObservation? in
                        let (wordString, wordRange) = word
                        guard let bounds = try? candidate.boundingBox(for: wordRange)?.boundingBox else { return nil }

                        // Generate (bounding box, word) structs for every word in the string.
                        return WordObservation(bounds: bounds, string: wordString, in: image)
                    }
                }

                completionHandler(observations)
            }

            operationQueue.addOperation(recognitionOperation)
        }
    }
    #elseif canImport(AppKit)
    @available(macOS 10.15, *)
    public func detectWords(in image: NSImage, completionHandler: @escaping (([WordObservation]?) -> Void)) {
        if let recognitionOperation = TextRecognitionOperation(image: image) {
            recognitionOperation.completionBlock = { [weak recognitionOperation] in
                // Detect all text in image.
                guard let results = recognitionOperation?.recognizedTextResults else { return }

                // For every observation, get the top candidate.
                let candidates = results.compactMap { $0.topCandidates(1).first }

                // Flatten together every struct.
                let observations = candidates.flatMap { candidate -> [WordObservation] in
                    // Take the top candidate's string and split it on word boundaries.
                    let words = candidate.string.words
                    return words.compactMap { word -> WordObservation? in
                        let (wordString, wordRange) = word
                        guard let bounds = try? candidate.boundingBox(for: wordRange)?.boundingBox else { return nil }

                        // Generate (bounding box, word) structs for every word in the string.
                        return WordObservation(bounds: bounds, string: wordString, in: image)
                    }
                }

                completionHandler(observations)
            }

            operationQueue.addOperation(recognitionOperation)
        }
    }
    #endif

    // MARK: Boilerplate

    private let operationQueue = OperationQueue()
}

private extension String {
    var words: [(String, Range<String.Index>)] {
        var words = [(String, Range<String.Index>)]()
        enumerateSubstrings(in: startIndex..<endIndex, options: [.byWords]) { word, wordRange, _, _ in
            guard let word = word else { return }
            words.append((word, wordRange))
        }

        return words
    }
}
