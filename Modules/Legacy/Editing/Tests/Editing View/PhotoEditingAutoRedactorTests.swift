//  Created by Geoff Pado on 11/14/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import Testing
import UIKit

import FactoryKit
import FactoryTesting

import DefaultsDoubles
import Geometry
import Observations

@testable import Editing

@MainActor @Suite(.container)
struct PhotoEditingAutoRedactorTests {
    init() {
        Container.shared.defaults.register { @MainActor in
            StubDefaultsProvider(autoRedactions: ["secret": true, "hidden": false])
        }
    }

    private let observations = ["secret", "hidden", "public"].map(Self.observation(for:))

    @Test func activeMatchingOnlyIncludesEnabledWords() {
        let redactor = PhotoEditingAutoRedactor(photoEditingView: PhotoEditingScrollView())

        let matches = redactor.matchingObservations(in: observations, onlyActive: true)

        #expect(Self.matchedWords(in: matches) == ["secret"])
    }

    @Test func inactiveMatchingIncludesEveryListedWord() {
        let redactor = PhotoEditingAutoRedactor(photoEditingView: PhotoEditingScrollView())

        let matches = redactor.matchingObservations(in: observations, onlyActive: false)

        #expect(Self.matchedWords(in: matches) == ["hidden", "secret"])
    }

    // MARK: Helpers

    private nonisolated static func observation(for word: String) -> CharacterObservation {
        CharacterObservation(
            bounds: Shape(bottomLeft: .zero, bottomRight: .zero, topLeft: .zero, topRight: .zero),
            textObservationUUID: UUID(),
            associatedString: word,
            range: word.startIndex..<word.endIndex
        )
    }

    /// The words matched by the word list. Category matches have no
    /// associated word, so they're ignored.
    private static func matchedWords(in matches: [any TextObservation]) -> Set<String> {
        Set(matches.compactMap { ($0 as? CharacterObservation)?.associatedWord })
    }
}
