//  Created by Geoff Pado on 5/1/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import CoreGraphics
import Foundation

import Geometry

public struct CharacterObservation: TextObservation, Hashable, RedactableObservation, Sendable {
    public let bounds: Shape
    public let textObservationUUID: UUID
    public let associatedString: String?
    public let range: Range<String.Index>?

    public var characterObservations: [CharacterObservation] { [self] }

    public init(bounds: Shape, textObservationUUID: UUID, associatedString: String? = nil, range: Range<String.Index>? = nil) {
        self.bounds = bounds
        self.textObservationUUID = textObservationUUID
        self.associatedString = associatedString
        self.range = range
    }

    public var associatedWord: String? {
        guard let associatedString, let range else { return nil }
        return String(associatedString[range])
    }

    public func union(with other: CharacterObservation) -> CharacterObservation {
        let combiningObservations = [self, other]
        guard let associatedString,
              let startIndex = combiningObservations.compactMap(\.range?.lowerBound).min(),
              let endIndex = combiningObservations.compactMap(\.range?.upperBound).max(),
              textObservationUUID == other.textObservationUUID
        else { return self }

        let range = startIndex..<endIndex
        return CharacterObservation(bounds: bounds, textObservationUUID: textObservationUUID, associatedString: associatedString, range: range)
    }
}
