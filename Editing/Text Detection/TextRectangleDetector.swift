//  Created by Geoff Pado on 4/22/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Vision
import UIKit

public class TextRectangleDetector: NSObject {
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

    @available(iOS 13.0, *)
    public func detectWords(in image: UIImage, completionHandler: @escaping (([WordObservation]?) -> Void)) {
        if let recognitionOperation = TextRecognitionOperation(image: image) {
            recognitionOperation.completionBlock = { [weak recognitionOperation] in
                // Detect all text in image.
                guard let results = recognitionOperation?.recognizedTextResults else { return }

                let observations = results.flatMap { result -> [WordObservation] in
                    // For every observation, get the top candidate.
                    guard let topCandidate = result.topCandidates(1).first else {
                        assertionFailure("had zero top candidates")
                        return []
                    }

                    let words = topCandidate.string.words
                    return words.compactMap { word -> WordObservation? in
                        let (wordString, wordRange) = word
                        guard let bounds = try? topCandidate.boundingBox(for: wordRange)?.boundingBox else { return nil }

                        // Generate (bounding box, word) structs for every word in the string.
                        return WordObservation(bounds: bounds, string: wordString, in: image, textObservationUUID: result.uuid)
                    }
                }

                completionHandler(observations)
            }

            operationQueue.addOperation(recognitionOperation)
        }
    }

    // MARK: Boilerplate

    private let operationQueue = OperationQueue()
}
