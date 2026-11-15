//  Created by Geoff Pado on 6/23/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Testing
import UIKit

import Detections
import struct Observations.RecognizedTextObservation
import struct Observations.TextRectangleObservation

@testable import Shortcuts

final class StubTextDetector: TextDetecting {
    private let recognizedStrings: [String]
    init(recognizedStrings: [String]) {
        self.recognizedStrings = recognizedStrings
    }

    func recognizeText(in image: UIImage) async throws -> [RecognizedTextObservation] {
        return try recognizedStrings.map(RecognizedTextObservation.init)
    }

    func detectText(in image: UIImage) async throws -> [TextRectangleObservation] {
        try recognizedStrings.map(TextRectangleObservation.init)
    }
}
