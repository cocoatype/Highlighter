//  Created by Geoff Pado on 9/1/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Testing

import FactoryKit
import FactoryTesting

import DefaultsDoubles
import DocumentScanning
import PhotoPermissions
import Purchasing
import PurchasingDoubles

@testable import Defaults
@testable import PhotoLibrary

@MainActor @Suite(.container)
struct PhotoLibraryBarButtonsProviderTests {
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

        let provider = PhotoLibraryBarButtonsProvider(
            isDocumentScannerSupported: isDocumentScannerSupported,
            permissionsRequester: PhotoLibraryPermissionsRequester()
        )

        let barButtons = provider.trailingNavigationItems
        let isIncluded = barButtons
            .contains(where: {
                $0 is DocumentScannerBarButtonItem
            })
        #expect(isIncluded == shouldBeIncluded)
    }
}
