//  Created by Geoff Pado on 7/16/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Testing

import FactoryKit
import FactoryTesting
import ViewInspector

import Purchasing
import PurchasingDoubles

@testable import Paywall

@MainActor @Suite(.container)
struct FooterPurchaseButtonTests {
    @Test(arguments: [
        (true, PurchaseState.unavailable, true),
        (false, .readyForPurchase(products: []), true),
        (true, .readyForPurchase(products: []), false),
    ])
    @available(iOS 16, *)
    func disabled(
        hasSelectedOption: Bool,
        purchaseState: PurchaseState,
        expectedDisabled: Bool
    ) throws {
        let paywallOption: PaywallOption? = if hasSelectedOption {
            PaywallOption(product: StubProduct(), isTrialEligible: false)
        } else { nil }
        Container.shared.purchaseRepository.register {
            SpyRepository(withCheese: purchaseState, noOnions: purchaseState)
        }
        let button = FooterPurchaseButton(selectedOption: paywallOption)
        let inspectedButton = try button.inspect()
        let isDisabled = try inspectedButton.find(ViewType.Button.self).isDisabled()
        #expect(isDisabled == expectedDisabled)
    }
}
