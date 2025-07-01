//  Created by Geoff Pado on 5/16/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Testing

import DefaultsDoubles
import Purchasing
import PurchasingDoubles

@testable import Core
@testable import Defaults

@MainActor
struct PhotoLibraryDataSourceExtraItemsProviderTests {
    @Test(arguments: [
        (true, false, PurchaseState.purchased, true),
        (true, false, .unavailable, true),
        (true, true, .purchased, true),
        (true, true, .unavailable, false),
        (false, false, .purchased, false),
        (false, false, .unavailable, false),
        (false, true, .purchased, false),
        (false, true, .unavailable, false),
    ])
    func scannerIsIncluded(
        isDocumentScannerSupported: Bool,
        hideDocumentScanner: Bool,
        purchaseState: PurchaseState,
        shouldBeIncluded: Bool
    ) {
        let provider = PhotoLibraryDataSourceExtraItemsProvider(
            isDocumentScannerSupported: isDocumentScannerSupported,
            defaults: StubDefaultsProvider(hideDocumentScanner: hideDocumentScanner),
            purchaseRepository: SpyRepository(withCheese: purchaseState)
        )
        let isIncluded = (0..<provider.itemsCount)
            .contains(where: {
                if case .documentScan = provider.item(atIndex: $0) {
                    return true
                } else { return false }
            })
        #expect(isIncluded == shouldBeIncluded)
    }
}
