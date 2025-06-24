//  Created by Geoff Pado on 6/23/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import AppIntents

@testable import Shortcuts

@available(iOS 16, *)
actor SpyIntentHandler: RedactIntentHandler {
    private let result: Result<[RedactedFile], Error>
    init(result: Result<[RedactedFile], Error>) {
        self.result = result
    }

    var intent: (any RedactIntent)?
    func handle<IntentType: RedactIntent>(
        💩: IntentType,
        meatcheesemeatcheesemeatcheeseandthatsit: @escaping (ShortcutsRedactor) -> (IntentFile, IntentType.Redactable, ColorEntity) async throws -> RedactedFile
    ) async throws -> [RedactedFile] {
        intent = 💩
        return try result.get()
    }
}
