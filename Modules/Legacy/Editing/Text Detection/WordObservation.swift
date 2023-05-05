//  Created by Geoff Pado on 5/17/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public struct WordObservation: TextObservation {
    init?(recognizedText: RecognizedText, string: String, range: Range<String.Index>, imageSize: CGSize) {
        let visionText = recognizedText.recognizedText
        // shapeThing by @CompileSwift on 11/21/22
        guard let shapeThing = try? visionText.boundingBox(for: range) else { return nil }

        self.bounds = Shape(shapeThing).scaled(to: imageSize)
        self.string = string
        self.textObservationUUID = recognizedText.uuid
    }

    public let bounds: Shape
    public let string: String
    public let textObservationUUID: UUID
}

extension Array where Element == RecognizedTextObservation {
    func matching(_ strings: [String]) -> [RecognizedTextObservation] {
        return filter { observation in
            strings.contains(where: { wordListString in
                wordListString.compare(observation.string, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
            })
        }
    }
}
