//  Created by Geoff Pado on 11/25/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import UIKit
import Vision

import Detections
import struct Observations.RecognizedText
import struct Observations.RecognizedTextObservation
import struct Observations.TextRectangleObservation
import protocol Observations.VisionText

/// Recognizes each of its strings as a separate line of text, and detects no
/// text rectangles.
final class StubTextDetector: TextDetecting {
    init(recognizedStrings: [String]) {
        self.recognizedStrings = recognizedStrings
    }

    func recognizeText(in image: DetectableImage) async throws -> [RecognizedTextObservation] {
        recognizedStrings.enumerated().compactMap { index, string in
            let visionText = StubVisionText(string: string, line: index)
            return RecognizedTextObservation(
                RecognizedText(recognizedText: visionText, uuid: UUID()),
                imageSize: CGSize(width: 1000, height: 1000)
            )
        }
    }

    func detectText(in image: DetectableImage) async throws -> [TextRectangleObservation] {
        []
    }

    private let recognizedStrings: [String]
}

/// Puts every range of its string in the same box, like Vision does for the
/// characters of a single word.
private struct StubVisionText: VisionText {
    let string: String
    let line: Int

    func boundingBox(for range: Range<String.Index>) throws -> VNRectangleObservation? {
        VNRectangleObservation(boundingBox: CGRect(x: 0.1, y: 0.1 * Double(line), width: 0.5, height: 0.05))
    }
}
