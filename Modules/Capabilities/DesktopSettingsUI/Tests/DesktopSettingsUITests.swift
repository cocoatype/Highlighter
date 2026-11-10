//  Created by Geoff Pado on 11/9/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import Testing
import UIKit

import FactoryKit
import FactoryTesting

import Purchasing
import PurchasingDoubles

@testable import DesktopSettingsUI

@MainActor @Suite(.container)
struct DesktopSettingsViewControllerTests {
    @Test(arguments: [
        (PurchaseState.purchased, DesktopSettingsViewController.Content.wordList),
        (.loading, .paywall),
        (.readyForPurchase(products: []), .paywall),
        (.unavailable, .paywall),
        (.purchasing, .paywall),
    ])
    func content(purchaseState: PurchaseState, expected: DesktopSettingsViewController.Content) {
        #expect(DesktopSettingsViewController.content(for: purchaseState) == expected)
    }

    @Test func showsCachedStateOnLoad() {
        Container.shared.purchaseRepository.register { SpyRepository(withCheese: .purchased) }
        let viewController = DesktopSettingsViewController()
        viewController.loadViewIfNeeded()
        #expect(viewController.displayedContent == .wordList)
        #expect(viewController.children.count == 1)
    }

    @available(iOS 16.0, *)
    @Test func switchesToWordListAfterPurchase() {
        Container.shared.purchaseRepository.register { SpyRepository(withCheese: .readyForPurchase(products: [])) }
        let viewController = DesktopSettingsViewController()
        viewController.loadViewIfNeeded()
        #expect(viewController.displayedContent == .paywall)

        viewController.update(for: .purchased)
        #expect(viewController.displayedContent == .wordList)
    }
}
