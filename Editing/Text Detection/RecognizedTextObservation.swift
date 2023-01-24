//  Created by Geoff Pado on 5/17/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Foundation
import Vision

public struct RecognizedTextObservation: TextObservation {
    init?(_ recognizedText: RecognizedText, imageSize: CGSize) {
        self.recognizedText = recognizedText
        self.imageSize = imageSize

        let underlyingText = recognizedText.recognizedText
        guard let boundingBox = try? underlyingText.boundingBox(for: underlyingText.string.startIndex..<underlyingText.string.endIndex) else { return nil }
        self.bounds = Shape(boundingBox).scaled(to: imageSize)
    }

    public let bounds: Shape
    public var string: String {
        recognizedText.recognizedText.string
    }

    public func wordObservation(for substring: Substring) -> WordObservation? {
        let wordRange = substring.startIndex ..< substring.endIndex
        return WordObservation(recognizedText: recognizedText, string: String(substring), range: wordRange, imageSize: imageSize)
    }

    public func wordObservations(matching: String) -> [WordObservation] {
        wordObservations { (wordString, _) in
            wordString.compare(matching, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
        }
    }

    var allWordObservations: [WordObservation] {
        wordObservations { _, _ in true }
    }

    private func wordObservations(matching: ((String, Range<String.Index>) -> Bool)) -> [WordObservation] {
        return recognizedText.string.words.filter(matching).compactMap { word in
            return WordObservation(recognizedText: recognizedText, string: word.0, range: word.1, imageSize: imageSize)
        }
    }

    private let recognizedText: RecognizedText
    private let imageSize: CGSize
}

extension Shape {
    init(_ observation: VNRectangleObservation) {
        self.bottomLeft = observation.bottomLeft
        self.bottomRight = observation.bottomRight
        self.topLeft = observation.topLeft
        self.topRight = observation.topRight
    }
}
