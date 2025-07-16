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
    }

    private var title: String {
        switch purchaseState {
        case .loading:
            return Strings.loadingTitle
        case .purchasing, .restoring:
            return Strings.purchasingTitle
        case .readyForPurchase:
            guard let selectedOption else { return Strings.loadingTitle }
            switch selectedOption.duration {
            case .monthly:
                return PaywallStrings.PaywallOption.Monthly.buttonTitle
            case .annual:
                if selectedOption.isTrialEligible {
                    return PaywallStrings.PaywallOption.YearlyWithTrial.buttonTitle
                } else {
                    return PaywallStrings.PaywallOption.Yearly.buttonTitle
                }
            case .oneTime:
                return PaywallStrings.PaywallOption.OneTime.buttonTitle
            case .unknown:
                return Strings.readyTitle(selectedOption.displayPrice)
            }
        case .unavailable:
            return Strings.loadingTitle
        case .purchased:
            return Strings.purchasedTitle
        }
    }

    private var disabled: Bool {
        switch purchaseState {
        case .readyForPurchase: return selectedOption != nil
        default: return true
        }
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

    private typealias Strings = PaywallStrings.PurchaseButton
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
