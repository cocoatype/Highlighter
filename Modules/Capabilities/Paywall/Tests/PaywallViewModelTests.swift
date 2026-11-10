//  Created by Geoff Pado on 11/9/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import Foundation
import Testing

import FactoryKit
import FactoryTesting

import Purchasing
import PurchasingDoubles

@testable import Paywall

@MainActor @Suite(.container)
struct PaywallViewModelTests {
    private struct TestError: Error {}

    private func option(_ duration: PurchaseDuration, price: Decimal = 1.99, isTrialEligible: Bool = false) -> PaywallOption {
        PaywallOption(product: StubProduct(price: price, duration: duration), isTrialEligible: isTrialEligible)
    }

    // MARK: Purchase Button

    @Test(arguments: [
        (true, PurchaseState.unavailable, false),
        (false, .readyForPurchase(products: []), false),
        (true, .readyForPurchase(products: []), true),
        (true, .loading, false),
        (true, .purchasing, false),
        (true, .purchased, false),
    ])
    func purchaseButtonEnabled(hasSelectedOption: Bool, purchaseState: PurchaseState, expectedEnabled: Bool) {
        Container.shared.purchaseRepository.register {
            SpyRepository(withCheese: purchaseState, noOnions: purchaseState)
        }
        let viewModel = PaywallViewModel()
        viewModel.selectedOption = hasSelectedOption ? option(.annual) : nil
        #expect(viewModel.isPurchaseButtonEnabled == expectedEnabled)
    }

    @Test(arguments: [
        (PurchaseDuration.monthly, false, Strings.PaywallOption.Monthly.buttonTitle),
        (.annual, false, Strings.PaywallOption.Yearly.buttonTitle),
        (.annual, true, Strings.PaywallOption.YearlyWithTrial.buttonTitle),
        (.oneTime, false, Strings.PaywallOption.OneTime.buttonTitle),
    ])
    func purchaseButtonTitleWhenReady(duration: PurchaseDuration, isTrialEligible: Bool, expectedTitle: String) {
        Container.shared.purchaseRepository.register {
            SpyRepository(withCheese: .readyForPurchase(products: []))
        }
        let viewModel = PaywallViewModel()
        viewModel.selectedOption = option(duration, isTrialEligible: isTrialEligible)
        #expect(viewModel.purchaseButtonTitle == expectedTitle)
    }

    @Test(arguments: [
        (PurchaseState.loading, Strings.PurchaseButton.loadingTitle),
        (.unavailable, Strings.PurchaseButton.loadingTitle),
        (.purchasing, Strings.PurchaseButton.purchasingTitle),
        (.restoring, Strings.PurchaseButton.purchasingTitle),
        (.purchased, Strings.PurchaseButton.purchasedTitle),
    ])
    func purchaseButtonTitle(purchaseState: PurchaseState, expectedTitle: String) {
        Container.shared.purchaseRepository.register {
            SpyRepository(withCheese: purchaseState)
        }
        let viewModel = PaywallViewModel()
        viewModel.selectedOption = option(.annual)
        #expect(viewModel.purchaseButtonTitle == expectedTitle)
    }

    @Test func purchaseButtonTitleWithoutSelection() {
        Container.shared.purchaseRepository.register {
            SpyRepository(withCheese: .readyForPurchase(products: []))
        }
        #expect(PaywallViewModel().purchaseButtonTitle == Strings.PurchaseButton.loadingTitle)
    }

    // MARK: Loading

    @Test func optionsAreSortedByPriceAndAnnualIsSelected() async {
        Container.shared.purchaseRepository.register {
            SpyRepository(products: [
                StubProduct(price: 14.99, duration: .oneTime),
                StubProduct(price: 4.99, duration: .annual),
                StubProduct(price: 0.99, duration: .monthly),
            ])
        }
        let viewModel = PaywallViewModel()
        await viewModel.loadProducts()

        #expect(viewModel.loadState == .loaded)
        #expect(viewModel.options.map(\.duration) == [.monthly, .annual, .oneTime])
        #expect(viewModel.selectedOption?.duration == .annual)
    }

    @Test func noAnnualOptionSelectsNothing() {
        let viewModel = PaywallViewModel()
        viewModel.setOptions([option(.monthly), option(.oneTime)])
        #expect(viewModel.selectedOption == nil)
    }

    @Test func existingSelectionIsKept() {
        let viewModel = PaywallViewModel()
        let monthly = option(.monthly)
        viewModel.setOptions([monthly, option(.annual)])
        viewModel.selectedOption = monthly
        viewModel.setOptions([option(.annual), monthly])
        #expect(viewModel.selectedOption == monthly)
    }

    @Test func pickerSkipsUnknownDurations() {
        let viewModel = PaywallViewModel()
        viewModel.setOptions([option(.monthly, price: 1), option(.unknown, price: 2), option(.annual, price: 3)])
        #expect(viewModel.pickerOptions.map(\.duration) == [.monthly, .annual])
    }

    @Test func loadFailureSetsFailedState() async {
        Container.shared.purchaseRepository.register {
            SpyRepository(productsError: TestError())
        }
        let viewModel = PaywallViewModel()
        await viewModel.loadProducts()
        #expect(viewModel.loadState == .failed)
        #expect(viewModel.options.isEmpty)
    }

    @Test func retryAfterFailureLoads() async {
        let repository = FailOnceRepository()
        Container.shared.purchaseRepository.register { repository }
        let viewModel = PaywallViewModel()
        await viewModel.loadProducts()
        #expect(viewModel.loadState == .failed)

        await viewModel.loadProducts()
        #expect(viewModel.loadState == .loaded)
        #expect(viewModel.options.count == 1)
    }

    @Test func refreshUsesLatestPurchaseState() async {
        Container.shared.purchaseRepository.register {
            SpyRepository(withCheese: .loading, noOnions: .readyForPurchase(products: []))
        }
        let viewModel = PaywallViewModel()
        #expect(viewModel.purchaseState == .loading)
        await viewModel.refreshPurchaseState()
        #expect(viewModel.purchaseState == .readyForPurchase(products: []))
    }

    // MARK: Purchasing

    @Test func successfulPurchaseCompletes() async {
        Container.shared.purchaseRepository.register {
            SpyRepository(withCheese: .readyForPurchase(products: []), purchaseResponse: .purchased)
        }
        let viewModel = PaywallViewModel()
        viewModel.selectedOption = option(.annual)

        await confirmation { completed in
            viewModel.onPurchaseCompleted = { completed() }
            await viewModel.purchase()
        }
        #expect(viewModel.purchaseState == .purchased)
    }

    @Test func failedPurchaseResetsStateAndReportsError() async {
        Container.shared.purchaseRepository.register {
            SpyRepository(withCheese: .readyForPurchase(products: []), purchaseError: TestError())
        }
        let viewModel = PaywallViewModel()
        viewModel.selectedOption = option(.annual)

        await confirmation { errorReported in
            viewModel.onPurchaseError = { errorReported() }
            await viewModel.purchase()
        }
        #expect(viewModel.purchaseState == .readyForPurchase(products: []))
        #expect(viewModel.isPurchaseButtonEnabled)
    }

    @Test func purchaseWithoutSelectionDoesNothing() async {
        Container.shared.purchaseRepository.register {
            SpyRepository(withCheese: .readyForPurchase(products: []), purchaseResponse: .purchased)
        }
        let viewModel = PaywallViewModel()
        await viewModel.purchase()
        #expect(viewModel.purchaseState == .readyForPurchase(products: []))
    }

    // MARK: Restoring

    @Test func failedRestoreReportsError() async {
        let viewModel = PaywallViewModel(restore: { throw TestError() })
        await confirmation { errorReported in
            viewModel.onRestoreError = { errorReported() }
            await viewModel.restore()
        }
    }

    @Test func successfulRestoreRefreshesPurchaseState() async {
        Container.shared.purchaseRepository.register {
            SpyRepository(withCheese: .readyForPurchase(products: []), noOnions: .purchased)
        }
        let viewModel = PaywallViewModel(restore: {})
        await confirmation { completed in
            viewModel.onPurchaseCompleted = { completed() }
            await viewModel.restore()
        }
        #expect(viewModel.purchaseState == .purchased)
    }

    // MARK: Descriptions

    @Test func descriptions() {
        let monthly = option(.monthly)
        #expect(PaywallViewModel.description(for: monthly) == Strings.PaywallOption.Monthly.message(monthly.displayPrice))
        #expect(PaywallViewModel.description(for: option(.unknown)) == nil)
        #expect(PaywallViewModel.shortName(for: option(.annual, isTrialEligible: true)) == Strings.PaywallOption.YearlyWithTrial.shortName)
    }
}

/// A repository whose first products request fails and later requests succeed.
private final class FailOnceRepository: PurchaseRepository, @unchecked Sendable {
    private struct TestError: Error {}
    private var hasFailed = false

    var withCheese: PurchaseState { .loading }
    var noOnions: PurchaseState { .loading }

    var products: [any PurchaseProduct] {
        get throws {
            guard hasFailed else {
                hasFailed = true
                throw TestError()
            }
            return [StubProduct(duration: .annual)]
        }
    }

    func start() {}
    func purchase(_ product: any PurchaseProduct) async throws -> PurchaseState { .loading }
    func restore() async -> PurchaseState { .loading }
}
