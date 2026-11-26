//  Created by Geoff Pado on 11/26/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import CoreGraphics
import Foundation
import Testing

import Geometry
import Observations

@testable import EditingEngine

struct CharacterObservationMatcherTests {
    private static let bounds = Shape(
        bottomLeft: CGPoint(x: 0, y: 5),
        bottomRight: CGPoint(x: 5, y: 5),
        topLeft: CGPoint(x: 0, y: 0),
        topRight: CGPoint(x: 5, y: 0)
    )

    private func observation(
        word: String,
        in string: String,
        uuid: UUID = UUID()
    ) throws -> CharacterObservation {
        let range = try #require(string.range(of: word))
        return CharacterObservation(
            bounds: Self.bounds,
            textObservationUUID: uuid,
            associatedString: string,
            range: range
        )
    }

    // MARK: matching(_:)

    @Test func matchingFindsExactWord() throws {
        let hello = try observation(word: "hello", in: "hello world")
        let world = try observation(word: "world", in: "hello world")

        #expect([hello, world].matching("world") == [world])
    }

    @Test func matchingIgnoresCaseAndDiacritics() throws {
        let cafe = try observation(word: "Café", in: "Café open")

        #expect([cafe].matching("cafe") == [cafe])
    }

    @Test func matchingTrimsSurroundingPunctuation() throws {
        let word = try observation(word: "(secret),", in: "a (secret), b")

        #expect([word].matching("\"secret\"") == [word])
    }

    @Test func matchingDoesNotMatchPartialWords() throws {
        let word = try observation(word: "secrets", in: "secrets")

        #expect([word].matching("secret").isEmpty)
    }

    @Test func matchingSkipsObservationsWithoutAssociatedWord() {
        let observation = CharacterObservation(bounds: Self.bounds, textObservationUUID: UUID())

        #expect([observation].matching("anything").isEmpty)
    }

    // MARK: byUUID

    @Test func byUUIDGroupsObservationsInOrder() throws {
        let firstUUID = UUID()
        let secondUUID = UUID()
        let one = try observation(word: "one", in: "one two", uuid: firstUUID)
        let two = try observation(word: "two", in: "one two", uuid: firstUUID)
        let three = try observation(word: "three", in: "three", uuid: secondUUID)

        let grouped = [one, three, two].byUUID

        #expect(grouped.count == 2)
        #expect(grouped[firstUUID] == [one, two])
        #expect(grouped[secondUUID] == [three])
    }

    @Test func byUUIDOfEmptyArrayIsEmpty() {
        #expect([CharacterObservation]().byUUID.isEmpty)
    }
}
