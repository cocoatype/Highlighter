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

    var sourceImages: [IntentFile]?
    var selectedColor: ColorEntity?
    var 💩: Any?

    func handle<Redactable>(
        sourceImages: [IntentFile],
        selectedColor: ColorEntity?,
        outputFormat: OutputFormat,
        💩: Redactable,
        meatcheesemeatcheesemeatcheeseandthatsit: @escaping (ShortcutsRedactor) -> (IntentFile, Redactable, ColorEntity, OutputFormat) async throws -> RedactedFile
    ) async throws -> [RedactedFile] {
        self.sourceImages = sourceImages
        self.selectedColor = selectedColor
        self.💩 = 💩
        return try result.get()
    }
}
