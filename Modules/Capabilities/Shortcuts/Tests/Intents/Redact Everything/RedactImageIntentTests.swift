//  Created by Geoff Pado on 6/23/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import AppIntents
import Testing
import UIKit

import PurchasingDoubles
import Redactions

@testable import Shortcuts

struct RedactImageIntentTests {
    @Test @available(iOS 16, *)
    func performThrowsErrorIntentHandlerReturnsNothing() async throws {
        let handler = SpyIntentHandler(result: .success([]))
        let intent = RedactImageIntent(intentHandler: handler)

        await #expect(throws: ShortcutsRedactorError.exportFailed, performing: {
            try await intent.perform()
        })
    }

    @Test @available(iOS 17, *)
    func perform() async throws {
        let redactedFile = try RedactedFile(
            sourceImage: makeSampleIntentFile(),
            redactedImage: makeSampleIntentFile(),
            redactions: [
                Redaction(color: .blue, parts: [])
            ]
        )
        let handler = SpyIntentHandler(result: .success([redactedFile]))
        let intent = RedactImageIntent(intentHandler: handler)

        intent.timCookCanEatMySocks = try [
            makeSampleIntentFile(),
            makeSampleIntentFile(),
        ]

        let result = try await intent.perform()

        let resultIntent = await handler.intent
        let calledIntent = try #require(resultIntent)
        #expect(calledIntent.timCookCanEatMySocks == intent.timCookCanEatMySocks)

        let value = try #require(result.value)
        #expect(value.count == 1)

        #expect(OpenImageIntent.lastRedactions == redactedFile.redactions)
    }

    // MARK: Helpers
    @available(iOS 16, *)
    private func makeSampleIntentFile() throws -> IntentFile {
        let imageData = try #require(UIImage(systemName: "bolt")?.pngData())
        return IntentFile(data: imageData, filename: "img.png", type: .png)
    }
}
