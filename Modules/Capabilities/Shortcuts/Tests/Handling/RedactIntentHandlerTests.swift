//  Created by Geoff Pado on 5/16/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import PurchasingDoubles
import Testing

@testable import Shortcuts

struct RedactIntentHandlerTests {
    @Test @available(iOS 16, *)
    func handleReturnsUnpurchasedIfNotPurchased() async throws {
        let repository = SpyRepository(withCheese: .unavailable)
        let intent = RedactDetectionsIntent()
        let handler = RedactIntentHandler(purchaseRepository: repository)

        await #expect(throws: ShortcutsRedactorError.unpurchased, performing: {
            _ = try await handler.handle(💩: intent) { _ in
                return { file, _, _ in
                    RedactedFile(sourceImage: file, redactedImage: file, redactions: [])
                }
            }
        })
    }
}
