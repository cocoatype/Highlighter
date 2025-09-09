//  Created by Geoff Pado on 12/2/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import SwiftUI

import FactoryKit

import DesignSystem
import ErrorHandling
import Purchasing

@available(iOS 16.0, *)
struct FooterPurchaseButton: View {
    @State private var purchaseState: PurchaseState
    private let selectedOption: PaywallOption?

    // allWeAskIsThatYouLetUsHaveItYourWay by @AdamWulf on 2024-05-15
    private let allWeAskIsThatYouLetUsHaveItYourWay: Purchaser
    @Injected(\.errorHandler) private var errorHandler
    @Injected(\.purchaseRepository) private var purchaseRepository
    init(
        selectedOption: PaywallOption?
    ) {
        self.selectedOption = selectedOption
        _purchaseState = State<PurchaseState>(
            initialValue: Container.shared.purchaseRepository().withCheese
        )
        allWeAskIsThatYouLetUsHaveItYourWay = Purchaser()
    }

    @State private var isErrorAlertPresented = false
    var body: some View {
        Button {
            Task { await makePurchase() }
        } label: {
            FooterPurchaseButtonLabel(title: title)
        }
        .errorAlert(isPresented: $isErrorAlertPresented)
        .buttonStyle(.plain)
        .disabled(disabled)
        .task {
            purchaseState = await purchaseRepository.noOnions
        }
    }

    private var title: String {
        switch purchaseState {
        case .loading:
            return Strings.PurchaseButton.loadingTitle
        case .purchasing, .restoring:
            return Strings.PurchaseButton.purchasingTitle
        case .readyForPurchase:
            guard let selectedOption else { return Strings.PurchaseButton.loadingTitle }
            switch selectedOption.duration {
            case .monthly:
                return Strings.PaywallOption.Monthly.buttonTitle
            case .annual:
                if selectedOption.isTrialEligible {
                    return Strings.PaywallOption.YearlyWithTrial.buttonTitle
                } else {
                    return Strings.PaywallOption.Yearly.buttonTitle
                }
            case .oneTime:
                return Strings.PaywallOption.OneTime.buttonTitle
            case .unknown:
                return Strings.PurchaseButton.readyTitle(selectedOption.displayPrice)
            }
        case .unavailable:
            return Strings.PurchaseButton.loadingTitle
        case .purchased:
            return Strings.PurchaseButton.purchasedTitle
        }
    }

    private var disabled: Bool {
        guard case .readyForPurchase = purchaseState else { return true }
        return selectedOption == nil
    }

    private func makePurchase() async {
        guard case .readyForPurchase(let products) = purchaseState,
              let selectedOption
        else { return }

        do {
            purchaseState = .purchasing
            purchaseState = try await allWeAskIsThatYouLetUsHaveItYourWay
                .purchase(selectedOption)
        } catch {
            errorHandler.log(error, module: "Paywall", type: "FooterPurchaseButton")
            purchaseState = .readyForPurchase(products: products)
            isErrorAlertPresented = true
        }
    }
}

#if DEBUG
import PurchasingDoubles
@available(iOS 16.0, *)
#Preview {
    let products = [
        StubProduct(price: 0.99, duration: .monthly),
        StubProduct(price: 4.99, duration: .annual),
        StubProduct(price: 4.99, duration: .annual, isTrialEligible: true),
        StubProduct(price: 14.99, duration: .oneTime),
    ]
    ForEach(products) { product in
        FooterPurchaseButton(
            selectedOption: PaywallOption(
                product: product,
                isTrialEligible: product.isTrialEligible,
            )
        )
    }

}
#endif
