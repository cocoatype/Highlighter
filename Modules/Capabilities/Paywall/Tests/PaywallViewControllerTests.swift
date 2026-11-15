//  Created by Geoff Pado on 12/4/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Testing
import UIKit

import FactoryKit
import FactoryTesting

import LoggingDoubles
import PurchasingDoubles

@testable import Paywall

@MainActor @Suite(.container)
struct PaywallViewControllerTests {
    @available(iOS 18.0, *)
    @Test func appearanceLoggedOnceOnAppear() {
        let logger = SpyLogger()
        Container.shared.logger.register { logger }
        Container.shared.purchaseRepository.register { SpyRepository() }

        let viewController = PaywallViewController()
        viewController.loadViewIfNeeded()
        viewController.viewDidAppear(false)
        viewController.viewDidAppear(false)

        let matchingEvents = logger.loggedEvents.count { event in
            event.name == .purchaseMarketingDisplayed
        }
        #expect(matchingEvents == 1)
    }

    @available(iOS 16.0, *)
    @Test func closeButtonOnlyShownWhenModal() {
        Container.shared.purchaseRepository.register { SpyRepository() }
        #if targetEnvironment(macCatalyst)
        #expect(PaywallViewController(isModal: true).showsCloseButton == false)
        #else
        #expect(PaywallViewController(isModal: true).showsCloseButton)
        #endif
        #expect(PaywallViewController(isModal: false).showsCloseButton == false)
    }

    @available(iOS 16.0, *)
    @Test func hostingControllerIsModalFormSheet() {
        Container.shared.purchaseRepository.register { SpyRepository() }
        let viewController = PaywallHostingController()
        #expect(viewController.modalPresentationStyle == .formSheet)
        #expect(viewController.preferredContentSize == CGSize(width: 640, height: 640))
    }

    @Test(arguments: [
        (CGFloat(320), 1),
        (639, 1),
        (640, 2),
        (1024, 2),
    ])
    func columnCount(width: CGFloat, expectedColumns: Int) {
        #expect(PaywallLayout.columnCount(forWidth: width) == expectedColumns)
    }

    @Test func itemsSkipDocumentScanningOnlyOnMac() {
        let imageNames = PaywallItem.all.map(\.imageName)
        #if targetEnvironment(macCatalyst)
        #expect(imageNames == ["Seek", "Shortcuts", "Support", "Systems"])
        #else
        #expect(imageNames == ["Seek", "Scanner", "Shortcuts", "Support", "Systems"])
        #endif
    }

    @Test func headerMargins() {
        #expect(PaywallHeaderView.margins(forWidth: 400) == NSDirectionalEdgeInsets(top: 40, leading: 20, bottom: 20, trailing: 20))
        #expect(PaywallHeaderView.margins(forWidth: 700) == NSDirectionalEdgeInsets(top: 40, leading: 40, bottom: 40, trailing: 40))
    }

    @available(iOS 16.0, *)
    @Test func footerShowsErrorWhenLoadingFails() async {
        struct TestError: Error {}
        Container.shared.purchaseRepository.register { SpyRepository(productsError: TestError()) }
        let viewController = PaywallViewController(isModal: true, viewModel: PaywallViewModel())
        viewController.loadViewIfNeeded()
        await viewController.viewModel.loadProducts()

        #expect(viewController.footerView.errorStack.isHidden == false)
        #expect(viewController.footerView.contentStack.isHidden)
        #expect(viewController.footerView.loadingIndicator.isHidden)
    }

    @available(iOS 16.0, *)
    @Test func footerShowsOptionsWhenLoaded() async {
        Container.shared.purchaseRepository.register {
            SpyRepository(
                withCheese: .readyForPurchase(products: []),
                noOnions: .readyForPurchase(products: []),
                products: [StubProduct(price: 0.99, duration: .monthly), StubProduct(price: 4.99, duration: .annual)]
            )
        }
        let viewController = PaywallViewController(isModal: true, viewModel: PaywallViewModel())
        viewController.loadViewIfNeeded()
        await viewController.viewModel.loadProducts()

        let footer = viewController.footerView
        #expect(footer.contentStack.isHidden == false)
        #expect(footer.durationPicker.numberOfSegments == 2)
        #expect(footer.durationPicker.selectedSegmentIndex == 1)
        #expect(footer.purchaseButton.isEnabled)
    }
}
