//  Created by Geoff Pado on 6/25/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Foundation

public struct CombinedCharacterObservation {
    public let textObservationUUID: UUID
    private let characterObservations: [CharacterObservation]
    public let associatedString: String

    public init?(characterObservations: [CharacterObservation]) {
        guard let firstUUID = characterObservations.first?.textObservationUUID,
              characterObservations.allSatisfy({ $0.textObservationUUID == firstUUID }),
              let firstString = characterObservations.first?.associatedString
        else { return nil }

        self.textObservationUUID = firstUUID
        self.characterObservations = characterObservations
        self.associatedString = firstString
    }

    public func characterObservations(with substrings: [Substring]) -> [CharacterObservation] {
        characterObservations(in: substrings.map { $0.startIndex ..< $0.endIndex })
    }

    public func characterObservations(in ranges: [Range<String.Index>]) -> [CharacterObservation] {
        characterObservations.filter { observation in
            guard let observationRange = observation.range else { return false }
            return ranges.contains { range in
                observationRange.overlaps(range)
            }
        }
    }
}
