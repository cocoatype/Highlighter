//  Created by Geoff Pado on 6/30/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import DefaultsDoubles
import Testing

@testable import Shortcuts

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
        let intent = GetAutoRedactionsIntent(defaults: defaults)
        intent.includeInactive = includeInactive

        let result = try await intent.perform()
        let actualWords = try #require(result.value)
        #expect(actualWords == expectedWords)
    }
}
