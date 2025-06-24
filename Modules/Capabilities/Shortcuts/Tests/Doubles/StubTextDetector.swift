//  Created by Geoff Pado on 6/23/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Testing
import UIKit

import Detections
import Observations

class StubTextDetector: TextDetector {
    private let recognizedStrings: [String]
    init(recognizedStrings: [String]) {
        self.recognizedStrings = recognizedStrings
    }

    override func recognizeText(in image: UIImage) async throws -> [Observations.RecognizedTextObservation] {
        return try recognizedStrings.map(RecognizedTextObservation.init)
    }

    override func detectText(in image: UIImage) async throws -> [TextRectangleObservation] {
        try recognizedStrings.map(TextRectangleObservation.init)
    }
}
