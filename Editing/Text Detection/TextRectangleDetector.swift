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

        if #available(iOSApplicationExtension 13.0, *), let recognitionOperation = TextRecognitionOperation(image: image) {
            recognitionOperation.completionBlock = { [weak recognitionOperation] in
                guard let recognizedTextObservations = recognitionOperation?.detectedTextResults else { return }
                let appStrings = recognizedTextObservations.compactMap { observation -> VNRecognizedText? in
                    guard let text = observation.topCandidates(1).first, text.string.contains("app") else { return nil }
                    return text

                }.compactMap { (text: VNRecognizedText) -> VNRectangleObservation? in
                    guard let range = text.string.range(of: "app") else { return nil }
                    return try? text.boundingBox(for: range)
                }

                dump(appStrings)
            }

            operationQueue.addOperation(recognitionOperation)
        }
    }

    // MARK: Boilerplate

    private let operationQueue = OperationQueue()
}
