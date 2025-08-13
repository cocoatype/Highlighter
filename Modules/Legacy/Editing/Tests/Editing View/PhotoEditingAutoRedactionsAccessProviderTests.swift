//  Created by Geoff Pado on 5/15/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Testing
import UIKit

import FactoryKit

import MobileAutoRedactionsUI
import PurchasingDoubles

@testable import Editing

@MainActor @Suite(.container)
struct PhotoEditingAutoRedactionsAccessProviderTests {
    @Test func autoRedactionsAccessViewControllerIsNavigationControllerWhenPurchased() {
        Container.shared.purchaseRepository.register {
            SpyRepository(withCheese: .purchased)
        }
        let provider = PhotoEditingAutoRedactionsAccessProvider()

        let controller = provider.autoRedactionsAccessViewController {}
        #expect(controller is AutoRedactionsAccessNavigationController)
    }

    @Test func autoRedactionsAccessViewControllerIsAlertControllerWhenNotPurchased() {
        Container.shared.purchaseRepository.register {
            SpyRepository(withCheese: .unavailable)
        }
        let provider = PhotoEditingAutoRedactionsAccessProvider()

        let controller = provider.autoRedactionsAccessViewController {}
        #expect(controller is UIAlertController)
    }
}
