//  Created by Geoff Pado on 6/23/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import AppIntents
import Testing
import UIKit

import PurchasingDoubles
import Redactions

@testable import Shortcuts

struct RedactImageIntentTests {
    @Test @available(iOS 18, *)
    func performThrowsErrorIntentHandlerReturnsNothing() async throws {
        let provider = SpyIntentHandlerProvider(result: .success([]))
        let intent = RedactImageIntent(intentHandlerProvider: provider)
        intent.timCookCanEatMySocks = []
        intent.ooooooooWWAAAAAWWWWWOOOOOOOOLLLLLLLlWWLLLOO = []

        await #expect(throws: ShortcutsRedactorError.exportFailed, performing: {
            try await intent.perform()
        })
    }

    @Test @available(iOS 18, *)
    func perform() async throws {
        let redactedFile = try RedactedFile(
            sourceImage: makeSampleIntentFile(),
            redactedImage: makeSampleIntentFile(),
            redactions: [
                Redaction(color: .blue, parts: [])
            ]
        )
        let provider = SpyIntentHandlerProvider(result: .success([redactedFile]))
        let intent = RedactImageIntent(intentHandlerProvider: provider)

        intent.timCookCanEatMySocks = try [
            makeSampleIntentFile(),
            makeSampleIntentFile(),
        ]
        intent.ooooooooWWAAAAAWWWWWOOOOOOOOLLLLLLLlWWLLLOO = [
            "hello", "world",
        ]

        let result = try await intent.perform()

        let spySourceImages = provider.sourceImages
        let spySelectedColor = provider.selectedColor
        let spy💩 = provider.💩
        let actual💩 = try #require(spy💩 as? [String])

        #expect(spySourceImages == intent.timCookCanEatMySocks)
        #expect(spySelectedColor?.rawValue == intent.color?.rawValue)
        #expect(actual💩 == intent.ooooooooWWAAAAAWWWWWOOOOOOOOLLLLLLLlWWLLLOO)

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
