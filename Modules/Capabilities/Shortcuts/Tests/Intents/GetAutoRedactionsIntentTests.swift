//  Created by Geoff Pado on 6/30/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Testing

import FactoryKit
import FactoryTesting

import DefaultsDoubles
import LoggingDoubles

@testable import Logging
@testable import Shortcuts

@MainActor @Suite(.container)
struct GetAutoRedactionsIntentTests {
    @MainActor @available(iOS 16, *) @Test(arguments: [
        (true, ["goodbye", "hello", "world"]),
        (false, ["hello", "world"]),
    ])
    func perform(
        includeInactive: Bool,
        expectedWords: [String]
    ) async throws {
        let defaults = StubDefaultsProvider(autoRedactions: [
            "hello": true,
            "goodbye": false,
            "world": true,
        ])
        Container.shared.defaults.register { defaults }
        let intent = GetAutoRedactionsIntent()
        intent.includeInactive = includeInactive

        let result = try await intent.perform()
        let actualWords = try #require(result.value)
        #expect(actualWords == expectedWords)
    }

    @available(iOS 16, *) @Test func logging() async throws {
        Container.shared.defaults.register { @MainActor in StubDefaultsProvider() }

        let logger = SpyLogger()
        Container.shared.logger.register { logger }

        let _ = try await GetAutoRedactionsIntent().perform()
        let event = try #require(logger.loggedEvents.first { loggedEvent in
            loggedEvent.name == "Shortcuts.intentUsed"
        })
        #expect(event.info["usage"] == "getAutoRedactions")
    }
}
