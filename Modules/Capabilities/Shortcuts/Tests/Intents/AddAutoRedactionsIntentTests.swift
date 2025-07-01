//  Created by Geoff Pado on 6/30/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Testing

import Defaults
import DefaultsDoubles

@testable import Shortcuts

@MainActor struct AddAutoRedactionsIntentTests {
    @available(iOS 16, *) @Test(arguments: [
        (true, ["goodbye", "hello", "world"]),
        (false, ["hello", "world"]),
    ])
    func perform(
        isActive: Bool,
        addedWords: [String]
    ) async throws {
        let defaults = StubDefaultsProvider(autoRedactions: [:])
        let intent = AddAutoRedactionsIntent(defaults: defaults)
        intent.isActive = isActive
        intent.addedWords = addedWords

        var expectedWords = [String: Bool]()
        for word in addedWords {
            expectedWords[word] = isActive
        }

        _ = try await intent.perform()
        let actualWords = try #require(defaults.value(for: Keys.autoRedactionsSet))
        #expect(actualWords == expectedWords)
    }

    @available(iOS 16, *) @Test func performOverwrite() async throws {
        let defaults = StubDefaultsProvider(autoRedactions: [
            "true": true,
            "false": true,
        ])

        let intent = AddAutoRedactionsIntent(defaults: defaults)
        intent.isActive = false
        intent.addedWords = ["false"]

        let expectedWords = [
            "true": true,
            "false": false,
        ]

        _ = try await intent.perform()
        let actualWords = try #require(defaults.value(for: Keys.autoRedactionsSet))
        #expect(actualWords == expectedWords)
    }
}
