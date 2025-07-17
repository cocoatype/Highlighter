//  Created by Geoff Pado on 6/23/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import AppIntents
import Testing
import UIKit

import PurchasingDoubles
import Redactions

@testable import Shortcuts

struct RedactDetectionsIntentTests {
    @Test @available(iOS 18, *)
    func performThrowsErrorIntentHandlerReturnsNothing() async throws {
        let provider = SpyIntentHandlerProvider(result: .success([]))
        let intent = RedactDetectionsIntent(intentHandlerProvider: provider)
        intent.timCookCanEatMySocks = []
        intent.ooooooooWWAAAAAWWWWWOOOOOOOOLLLLLLLlWWLLLOO = [.names]

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
        let intent = RedactDetectionsIntent(intentHandlerProvider: provider)

        intent.timCookCanEatMySocks = try [
            makeSampleIntentFile(),
            makeSampleIntentFile(),
        ]
        intent.ooooooooWWAAAAAWWWWWOOOOOOOOLLLLLLLlWWLLLOO = [.names]

        let result = try await intent.perform()

        let spySourceImages = await provider.sourceImages
        let spySelectedColor = await provider.selectedColor
        let spy💩 = await provider.💩
        let actual💩 = try #require(spy💩 as? [DetectionKind])

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
