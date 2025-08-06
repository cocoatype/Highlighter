//  Created by Geoff Pado on 5/16/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Testing

import FactoryKit
import FactoryTesting

import DefaultsDoubles
import PhotoPermissions
import Purchasing
import PurchasingDoubles

@testable import Defaults
@testable import PhotoLibrary

@MainActor @Suite(.container)
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
        Container.shared.defaults.register { @MainActor in
            StubDefaultsProvider(hideDocumentScanner: hideDocumentScanner)
        }
        Container.shared.purchaseRepository.register {
            SpyRepository(withCheese: purchaseState)
        }

        let provider = PhotoLibraryDataSourceExtraItemsProvider(
            isDocumentScannerSupported: isDocumentScannerSupported,
            permissionsRequester: PhotoLibraryPermissionsRequester()
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
