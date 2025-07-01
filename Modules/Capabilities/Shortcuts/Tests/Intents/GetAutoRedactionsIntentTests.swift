//  Created by Geoff Pado on 6/30/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Testing

import FactoryKit
import FactoryTesting

import DefaultsDoubles

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
}
