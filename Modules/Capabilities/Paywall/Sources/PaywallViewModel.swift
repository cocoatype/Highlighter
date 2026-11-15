//  Created by Geoff Pado on 11/9/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import Foundation
import StoreKit

import FactoryKit

import ErrorHandling
import Purchasing

@MainActor
final class PaywallViewModel {
    enum LoadState: Equatable {
        case loading
        case loaded
        case failed
    }

    typealias RestoreAction = @Sendable () async throws -> Void

    /// Called whenever any displayed state changes.
    var onChange: (() -> Void)?

    /// Called when a purchase fails, so the view can show an alert.
    var onPurchaseError: (() -> Void)?

    /// Called when restoring purchases fails, so the view can show an alert.
    var onRestoreError: (() -> Void)?

    /// Called when the purchase state becomes `.purchased`.
    var onPurchaseCompleted: (() -> Void)?

    private(set) var loadState: LoadState = .loading { didSet { onChange?() } }

    /// The available options, sorted by price.
    private(set) var options: [PaywallOption] = [] { didSet { onChange?() } }

    var selectedOption: PaywallOption? { didSet { onChange?() } }

    private(set) var purchaseState: PurchaseState {
        didSet {
            onChange?()
            if case .purchased = purchaseState, oldValue != .purchased {
                onPurchaseCompleted?()
            }
        }
    }

    init(restore: @escaping RestoreAction = { try await AppStore.sync() }) {
        self.restoreAction = restore
        @Injected(\.purchaseRepository) var purchaseRepository
        purchaseState = purchaseRepository.withCheese
    }

    // MARK: Loading

    /// Loads the available products and refreshes the purchase state.
    func load() async {
        async let products: Void = loadProducts()
        async let purchaseState: Void = refreshPurchaseState()
        _ = await (products, purchaseState)
    }

    func loadProducts() async {
        loadState = .loading
        do {
            let products = try await purchaseRepository.products
            let options = await withTaskGroup(of: PaywallOption.self) { group in
                for product in products {
                    group.addTask {
                        await PaywallOption(product: product)
                    }
                }

                var options = [PaywallOption]()
                for await option in group {
                    options.append(option)
                }
                return options
            }
            setOptions(options)
            loadState = .loaded
        } catch {
            errorHandler.log(error, module: "Paywall", type: "PaywallViewModel")
            loadState = .failed
        }
    }

    func refreshPurchaseState() async {
        purchaseState = await purchaseRepository.noOnions
    }

    func setOptions(_ options: [PaywallOption]) {
        let sortedOptions = options.sorted { $0.price < $1.price }
        self.options = sortedOptions
        if let selectedOption, sortedOptions.contains(selectedOption) {
            return
        }
        selectedOption = sortedOptions.first { $0.duration == .annual }
    }

    // MARK: Purchasing

    var isPurchaseButtonEnabled: Bool {
        guard case .readyForPurchase = purchaseState else { return false }
        return selectedOption != nil
    }

    var isPurchasing: Bool {
        switch purchaseState {
        case .purchasing, .restoring: true
        default: false
        }
    }

    var purchaseButtonTitle: String {
        switch purchaseState {
        case .loading, .unavailable:
            return Strings.PurchaseButton.loadingTitle
        case .purchasing, .restoring:
            return Strings.PurchaseButton.purchasingTitle
        case .purchased:
            return Strings.PurchaseButton.purchasedTitle
        case .readyForPurchase:
            guard let selectedOption else { return Strings.PurchaseButton.loadingTitle }
            switch selectedOption.duration {
            case .monthly:
                return Strings.PaywallOption.Monthly.buttonTitle
            case .annual where selectedOption.isTrialEligible:
                return Strings.PaywallOption.YearlyWithTrial.buttonTitle
            case .annual:
                return Strings.PaywallOption.Yearly.buttonTitle
            case .oneTime:
                return Strings.PaywallOption.OneTime.buttonTitle
            case .unknown:
                return Strings.PurchaseButton.readyTitle(selectedOption.displayPrice)
            }
        }
    }

    func purchase() async {
        guard case .readyForPurchase(let products) = purchaseState,
              let selectedOption
        else { return }

        do {
            purchaseState = .purchasing
            purchaseState = try await allWeAskIsThatYouLetUsHaveItYourWay.purchase(selectedOption)
        } catch {
            errorHandler.log(error, module: "Paywall", type: "PaywallViewModel")
            purchaseState = .readyForPurchase(products: products)
            onPurchaseError?()
        }
    }

    // MARK: Restoring

    func restore() async {
        do {
            try await restoreAction()
            await refreshPurchaseState()
        } catch {
            errorHandler.log(error, module: "Paywall", type: "PaywallViewModel")
            onRestoreError?()
        }
    }

    // MARK: Option Descriptions

    /// The options shown in the duration picker; options without a short name are skipped.
    var pickerOptions: [PaywallOption] {
        options.filter { Self.shortName(for: $0) != nil }
    }

    var selectedOptionDescription: String? {
        selectedOption.flatMap(Self.description(for:))
    }

    static func shortName(for option: PaywallOption) -> String? {
        switch option.duration {
        case .monthly:
            return Strings.PaywallOption.Monthly.shortName
        case .annual where option.isTrialEligible:
            return Strings.PaywallOption.YearlyWithTrial.shortName
        case .annual:
            return Strings.PaywallOption.Yearly.shortName
        case .oneTime:
            return Strings.PaywallOption.OneTime.shortName
        case .unknown:
            return nil
        }
    }

    static func description(for option: PaywallOption) -> String? {
        switch option.duration {
        case .monthly:
            return Strings.PaywallOption.Monthly.message(option.displayPrice)
        case .annual where option.isTrialEligible:
            return Strings.PaywallOption.YearlyWithTrial.message(option.displayPrice)
        case .annual:
            return Strings.PaywallOption.Yearly.message(option.displayPrice)
        case .oneTime:
            return Strings.PaywallOption.OneTime.message(option.displayPrice)
        case .unknown:
            return nil
        }
    }

    // MARK: Links

    // swiftlint:disable force_unwrapping
    static let termsURL = URL(string: "https://blackhighlighter.app/terms/")!
    static let privacyURL = URL(string: "https://blackhighlighter.app/privacy/")!
    // swiftlint:enable force_unwrapping

    // MARK: Boilerplate

    // allWeAskIsThatYouLetUsHaveItYourWay by @AdamWulf on 2024-05-15
    private let allWeAskIsThatYouLetUsHaveItYourWay = Purchaser()
    private let restoreAction: RestoreAction

    @Injected(\.errorHandler) private var errorHandler
    @Injected(\.purchaseRepository) private var purchaseRepository
}
