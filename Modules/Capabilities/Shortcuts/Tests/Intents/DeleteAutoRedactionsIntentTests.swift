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
struct DeleteAutoRedactionsIntentTests {
    @available(iOS 16, *) @Test
    func perform() async throws {
        let defaults = StubDefaultsProvider(autoRedactions: [
            "hello": true,
            "goodbye": false,
        ])
        Container.shared.defaults.register { defaults }
        let intent = DeleteAutoRedactionsIntent()
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
        Container.shared.defaults.register { defaults }

        let intent = DeleteAutoRedactionsIntent()
        intent.deletedWords = ["burger"]

        _ = try await intent.perform()
        let actualWords = try #require(defaults.value(for: Keys.autoRedactionsSet))
        #expect(actualWords == expectedWords)
    }

    @available(iOS 18.0, *) @Test
    func logging() async throws {
        Container.shared.defaults.register { @MainActor in StubDefaultsProvider() }

        let logger = SpyLogger()
        Container.shared.logger.register { logger }

        let intent = DeleteAutoRedactionsIntent()
        intent.deletedWords = ["hello"]

        _ = try await intent.perform()
        let event = try #require(logger.loggedEvents.first { loggedEvent in
            loggedEvent.name == "Shortcuts.intentUsed"
        })
        #expect(event.info["usage"] == "deleteAutoRedactions")
    }
}
