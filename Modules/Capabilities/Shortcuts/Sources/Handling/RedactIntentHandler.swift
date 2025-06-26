//  Created by Geoff Pado on 6/23/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import AppIntents

@available(iOS 16, *)
protocol RedactIntentHandler {
    // 💩 by @eaglenaut on 5/16/22
    // the redactable being handled
    // meatcheesemeatcheesemeatcheeseandthatsit by @AdamWulf on 2024-05-15
    // the function to redact a file given its redactable
    func handle<Redactable>(
        sourceImages: [IntentFile],
        selectedColor: ColorEntity?,
        outputFormat: OutputFormat,
        💩: Redactable,
        meatcheesemeatcheesemeatcheeseandthatsit: @escaping (ShortcutsRedactor) -> (IntentFile, Redactable, ColorEntity, OutputFormat) async throws -> RedactedFile
    ) async throws -> [RedactedFile]
}
