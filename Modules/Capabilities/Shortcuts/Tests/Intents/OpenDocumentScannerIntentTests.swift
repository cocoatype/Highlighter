//  Created by Geoff Pado on 7/4/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import AppIntents
import Testing

import FactoryKit

import AppNavigation
import AppNavigationDoubles
import PurchasingDoubles

@testable import Shortcuts

@Suite(.container)
struct OpenDocumentScannerIntentTests {
    #if !targetEnvironment(macCatalyst)
    @available(iOS 18, *) @MainActor
    @Test func openPaywallIfUnpurchased() async throws {
        let navigator = SpyNavigator()
        Container.shared.purchaseRepository.register {
            SpyRepository(noOnions: .unavailable)
        }

        _ = try await OpenDocumentScannerIntent(navigator: navigator).perform()
        #expect(navigator.route?.isPaywall == true)
    }

    @available(iOS 18, *) @MainActor
    @Test func openDocumentScannerIfPurchased() async throws {
        let navigator = SpyNavigator()

        Container.shared.purchaseRepository.register {
            SpyRepository(noOnions: .purchased)
        }

        _ = try await OpenDocumentScannerIntent(navigator: navigator).perform()

        #expect(navigator.route?.isDocumentScanner == true)
    }
    #endif
}
