//  Created by Geoff Pado on 6/30/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Testing

import FactoryKit
import FactoryTesting

import Defaults
import DefaultsDoubles
import LoggingDoubles

@testable import Logging
@testable import Shortcuts

@MainActor @Suite(.container)
struct AddAutoRedactionsIntentTests {
    @available(iOS 16, *) @Test(arguments: [
        (true, ["goodbye", "hello", "world"]),
        (false, ["hello", "world"]),
    ])
    func perform(
        isActive: Bool,
        addedWords: [String]
    ) async throws {
        let defaults = StubDefaultsProvider(autoRedactions: [:])
        Container.shared.defaults.register { defaults }
        let intent = AddAutoRedactionsIntent()
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
        Container.shared.defaults.register { defaults }

        let intent = AddAutoRedactionsIntent()
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

    @available(iOS 16, *) @Test func logging() async throws {
        Container.shared.defaults.register { @MainActor in StubDefaultsProvider() }

        let logger = SpyLogger()
        Container.shared.logger.register { logger }

        let intent = AddAutoRedactionsIntent()
        intent.addedWords = ["hello"]

        _ = try await intent.perform()
        let event = try #require(logger.loggedEvents.first { loggedEvent in
            loggedEvent.name == "Shortcuts.intentUsed"
        })
        #expect(event.info["usage"] == "addAutoRedactions")
    }
}
