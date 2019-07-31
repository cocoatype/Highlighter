//  Created by Geoff Pado on 4/22/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Vision
import UIKit

public class TextRectangleDetector: NSObject {
    public func detectTextRectangles(in image: UIImage, completionHandler: (([TextObservation]?) -> Void)? = nil) {
        guard let detectionOperation = TextRectangleDetectionOperation(image: image) else {
            completionHandler?(nil)
            return
        }

        detectionOperation.completionBlock = { [weak detectionOperation] in
            let detectedTextObservations = detectionOperation?.textRectangleResults?.map { TextObservation($0, in: image) }
            completionHandler?(detectedTextObservations)
        }

        operationQueue.addOperation(detectionOperation)

    }

    @available(iOS 13.0, *)
    public func locateTextRectangles(forWordsIn wordList: [String], in image: UIImage, completionHandler: @escaping (([TextObservation]?) -> Void)) {
        if let recognitionOperation = TextRecognitionOperation(image: image) {
            recognitionOperation.completionBlock = { [weak recognitionOperation] in
                let observations = recognitionOperation?.recognizedTextResults?.compactMap { result -> VNRecognizedText? in
                    guard let text = result.topCandidates(1).first else { return nil }
                    let recognizedString = text.string
                    guard wordList.contains(where: { listedWord in
                        recognizedString.contains(listedWord)
                    }) else {
                        return nil
                    }

                    return text
                }.compactMap { text in
                    return wordList.compactMap { word -> VNRectangleObservation? in
                        guard let range = text.string.range(of: word) else { return nil }
                        return try? text.boundingBox(for: range)
                    }
                }.flatMap { $0 }.map { TextObservation($0, in: image) }
                completionHandler(observations)
            }

            operationQueue.addOperation(recognitionOperation)
        }
    }

    // MARK: Boilerplate

    private let operationQueue = OperationQueue()
}
