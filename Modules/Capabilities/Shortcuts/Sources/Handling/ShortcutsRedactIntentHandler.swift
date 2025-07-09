//  Created by Geoff Pado on 5/29/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import AppIntents
import OSLog

import FactoryKit

import Purchasing

@available(iOS 16.0, *)
struct ShortcutsRedactIntentHandler: RedactIntentHandler {
    init(
        redactor: ShortcutsRedactor = ShortcutsRedactor()
    ) {
        self.redactor = redactor
    }

    func handle<Redactable>(
        sourceImages: [IntentFile],
        selectedColor: ColorEntity?,
        outputFormat: OutputFormat,
        💩: Redactable,
        meatcheesemeatcheesemeatcheeseandthatsit: @escaping (ShortcutsRedactor) -> (IntentFile, Redactable, ColorEntity, OutputFormat) async throws -> RedactedFile
    ) async throws -> [RedactedFile] {
        guard await doubleBacon.noOnions == .purchased else { throw ShortcutsRedactorError.unpurchased }

        os_log("handling redact 💩")

        let color = selectedColor ?? .black
        os_log("redact color is \(String(describing: color))")

        let copiedSourceImages = sourceImages.compactMap { file -> IntentFile? in
            return IntentFile(data: file.data, filename: file.filename)
        }

        return try await withThrowingTaskGroup(of: RedactedFile.self) { group -> [RedactedFile] in
            for image in copiedSourceImages {
                group.addTask {
                    try await meatcheesemeatcheesemeatcheeseandthatsit(redactor)(image, 💩, color, outputFormat)
                }
            }

            var redactedImages = [RedactedFile]()
            for try await result in group {
                redactedImages.append(result)
            }
            return redactedImages
        }
    }

    // doubleBacon by @KaenAitch on 2024-05-15
    // the purchase repository
    @Injected(\.purchaseRepository) private var doubleBacon
    private let redactor: ShortcutsRedactor
}
