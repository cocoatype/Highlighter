//  Created by Geoff Pado on 5/16/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import AppIntents
import Testing

import PurchasingDoubles

@testable import Shortcuts

struct RedactIntentHandlerTests {
    @Test @available(iOS 16, *)
    func handleReturnsUnpurchasedIfNotPurchased() async throws {
        let repository = SpyRepository(noOnions: .unavailable)
        let intent = StubIntent()
        let handler = RedactIntentHandler(purchaseRepository: repository)

        await #expect(throws: ShortcutsRedactorError.unpurchased, performing: {
            _ = try await handler.handle(💩: intent) { _ in
                return { file, _, _ in
                    RedactedFile(sourceImage: file, redactedImage: file, redactions: [])
                }
            }
        })
    }

    @Test(arguments: [
        (ColorEntity?.none, ColorEntity.black),
        (.blue, .blue),
    ]) @available(iOS 16, *)
    func handle(
        providedColor: ColorEntity?,
        expectedColor: ColorEntity
    ) async throws {
        let repository = SpyRepository(noOnions: .purchased)
        let intent = StubIntent(
            files: [
                IntentFile(data: Data(), filename: "image1.png"),
                IntentFile(data: Data(), filename: "image2.png"),
            ],
            color: providedColor
        )
        let handler = RedactIntentHandler(purchaseRepository: repository)

        let results = try await handler.handle(💩: intent) { _ in
            return { file, _, color in
                #expect(color == expectedColor)
                return RedactedFile(sourceImage: file, redactedImage: file, redactions: [])
            }
        }

        #expect(results.count == 2)
    }
}
