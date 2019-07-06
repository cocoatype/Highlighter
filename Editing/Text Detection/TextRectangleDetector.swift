//  Created by Geoff Pado on 4/22/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

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

    // MARK: Boilerplate

    private let operationQueue = OperationQueue()
}
