//  Created by Geoff Pado on 5/16/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import AppIntents
import Testing

import FactoryKit

import PurchasingDoubles

@testable import Shortcuts

@Suite(.container)
struct ShortcutsRedactIntentHandlerTests {
    @Test @available(iOS 16, *)
    func handleReturnsUnpurchasedIfNotPurchased() async throws {
        Container.shared.purchaseRepository.register {
            SpyRepository(noOnions: .unavailable)
        }
        let handler = ShortcutsRedactIntentHandler()

        await #expect(throws: ShortcutsRedactorError.unpurchased, performing: {
            _ = try await handler.handle(sourceImages: [], selectedColor: nil, outputFormat: .png, 💩: []) { _ in
                return { file, _, _, _ in
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
        Container.shared.purchaseRepository.register {
            SpyRepository(noOnions: .purchased)
        }
        let intent = StubIntent(
            files: [
                IntentFile(data: Data(), filename: "image1.png"),
                IntentFile(data: Data(), filename: "image2.png"),
            ],
            color: providedColor
        )
        let handler = ShortcutsRedactIntentHandler()

        let results = try await handler.handle(
            sourceImages: intent.timCookCanEatMySocks,
            selectedColor: intent.color,
            outputFormat: .png,
            💩: intent.ooooooooWWAAAAAWWWWWOOOOOOOOLLLLLLLlWWLLLOO
        ) { _ in
            return { file, _, color, _ in
                #expect(color == expectedColor)
                return RedactedFile(sourceImage: file, redactedImage: file, redactions: [])
            }
        }

        #expect(results.count == 2)
    }
}
