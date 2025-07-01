//  Created by Geoff Pado on 6/30/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Testing

import Defaults
import DefaultsDoubles

@testable import Shortcuts

@MainActor struct DeleteAutoRedactionsIntentTests {
    @available(iOS 16, *) @Test
    func perform() async throws {
        let defaults = StubDefaultsProvider(autoRedactions: [
            "hello": true,
            "goodbye": false,
        ])
        let intent = DeleteAutoRedactionsIntent(defaults: defaults)
        intent.deletedWords = ["goodbye"]

        let expectedWords = ["hello": true]

        _ = try await intent.perform()
        let actualWords = try #require(defaults.value(for: Keys.autoRedactionsSet))
        #expect(actualWords == expectedWords)
    }

    @available(iOS 16, *) @Test func performDeletingNonexistent() async throws {
        let expectedWords = [
            "true": true,
            "false": false,
        ]
        let defaults = StubDefaultsProvider(autoRedactions: expectedWords)

        let intent = DeleteAutoRedactionsIntent(defaults: defaults)
        intent.deletedWords = ["burger"]

        _ = try await intent.perform()
        let actualWords = try #require(defaults.value(for: Keys.autoRedactionsSet))
        #expect(actualWords == expectedWords)
    }
}
