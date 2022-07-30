//  Created by Geoff Pado on 5/17/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Foundation
import Vision

public struct RecognizedTextObservation: TextObservation {
    init?(_ recognizedText: RecognizedText, imageSize: CGSize) {
        self.recognizedText = recognizedText
        self.imageSize = imageSize

        let underlyingText = recognizedText.recognizedText
        guard let boundingBox = try? underlyingText.boundingBox(for: underlyingText.string.startIndex..<underlyingText.string.endIndex)?.boundingBox else { return nil }
        self.bounds = CGRect.flippedRect(from: boundingBox, scaledTo: imageSize)
    }

    public let bounds: CGRect
    public var string: String {
        recognizedText.recognizedText.string
    }

    public func wordObservation(for substring: Substring) -> WordObservation? {
        let wordRange = substring.startIndex ..< substring.endIndex
        guard let bounds = try? recognizedText.recognizedText.boundingBox(for: wordRange)?.boundingBox else { return nil }
        return WordObservation(bounds: bounds, string: String(substring), imageSize: imageSize, textObservationUUID: recognizedText.uuid)
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
            let (wordString, wordRange) = word
            guard let bounds = try? recognizedText.recognizedText.boundingBox(for: wordRange)?.boundingBox else { return nil }

            // Generate (bounding box, word) structs for every word in the string.
            return WordObservation(bounds: bounds, string: wordString, imageSize: imageSize, textObservationUUID: recognizedText.uuid)
        }
    }

    private let recognizedText: RecognizedText
    private let imageSize: CGSize
}
