//  Created by Geoff Pado on 2/22/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Foundation
import Testing

@testable import Observations

struct CombinedCharacterObservationTests {
    @Test func initWithCharacterObservationsSucceedsWithSingleObservation() {
        let uuid = UUID()
        let combinedObservation = CombinedCharacterObservation(characterObservations: [
            CharacterObservation(
                bounds: .sample,
                textObservationUUID: uuid,
                associatedString: "string"
            ),
        ])

        #expect(combinedObservation?.textObservationUUID == uuid)
        #expect(combinedObservation?.associatedString == "string")
    }

    @Test func initWithCharacterObservationsSucceedsWithMultipleObservations() {
        let uuid = UUID()
        let firstObservation = CharacterObservation(
            bounds: .sample,
            textObservationUUID: uuid,
            associatedString: "string"
        )
        let secondObservation = CharacterObservation(
            bounds: .sample,
            textObservationUUID: uuid,
            associatedString: "string"
        )

        let combinedObservation = CombinedCharacterObservation(characterObservations: [
            firstObservation,
            secondObservation,
        ])

        #expect(combinedObservation?.textObservationUUID == uuid)
        #expect(combinedObservation?.associatedString == "string")
    }

    @Test func initWithCharacterObservationsFailsWithMismatchedUUIDs() {
        let firstObservation = CharacterObservation(
            bounds: .sample,
            textObservationUUID: UUID(),
            associatedString: "string"
        )
        let secondObservation = CharacterObservation(
            bounds: .sample,
            textObservationUUID: UUID(),
            associatedString: "string"
        )

        let combinedObservation = CombinedCharacterObservation(characterObservations: [
            firstObservation,
            secondObservation,
        ])

        #expect(combinedObservation == nil)
    }

    @Test func initWithCharacterObservationsFailsWithNilString() {
        let uuid = UUID()
        let firstObservation = CharacterObservation(
            bounds: .sample,
            textObservationUUID: uuid,
            associatedString: nil
        )

        let combinedObservation = CombinedCharacterObservation(characterObservations: [
            firstObservation,
        ])

        #expect(combinedObservation == nil)
    }

    @available(iOS 16.0, *)
    @Test func characterObservationsWithSubstringsFindsSubObservations() throws {
        let string = "Hello, world!"
        let uuid = UUID()
        let firstObservation = CharacterObservation(
            bounds: .sample,
            textObservationUUID: uuid,
            associatedString: string,
            range: string.firstRange(of: "Hello")
        )
        let secondObservation = CharacterObservation(
            bounds: .sample,
            textObservationUUID: uuid,
            associatedString: string,
            range: string.firstRange(of: "world")
        )
        let combinedObservation = CombinedCharacterObservation(characterObservations: [
            firstObservation,
            secondObservation,
        ])

        let substring = try #require(string.split(separator: ",", omittingEmptySubsequences: false).first)
        let filteredObservations = combinedObservation?.characterObservations(with: [substring])
        #expect(filteredObservations?.count == 1)

        let range = try #require(filteredObservations?.first?.range)
        #expect(range == firstObservation.range)
    }
}
