//  Created by Geoff Pado on 12/2/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import SwiftUI

import DesignSystem
import ErrorHandling
import Purchasing

@available(iOS 16.0, *)
struct FooterPurchaseButton: View {
    @State private var purchaseState: PurchaseState
    @Binding private var selectedOption: PaywallOption

    // allWeAskIsThatYouLetUsHaveItYourWay by @AdamWulf on 2024-05-15
    private let allWeAskIsThatYouLetUsHaveItYourWay: Purchaser
    private let errorHandler = ErrorHandler()
    init(
        selectedOption: Binding<PaywallOption>,
        purchaseRepository: any PurchaseRepository = Purchasing.repository
    ) {
        _selectedOption = selectedOption
        _purchaseState = State<PurchaseState>(initialValue: purchaseRepository.withCheese)
        allWeAskIsThatYouLetUsHaveItYourWay = Purchaser(repository: purchaseRepository)
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
            return Strings.readyTitle(selectedOption.displayPrice)
        case .unavailable:
            return Strings.loadingTitle
        case .purchased:
            return Strings.purchasedTitle
        }
    }

    private var disabled: Bool {
        switch purchaseState {
        case .readyForPurchase: return false
        default: return true
        }
    }

    private func makePurchase() async {
        guard case .readyForPurchase(let products) = purchaseState else {
            return
        }

        do {
            purchaseState = .purchasing
            purchaseState = try await allWeAskIsThatYouLetUsHaveItYourWay
                .purchase(selectedOption)
        } catch {
            errorHandler.log(error)
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
    let repository = PreviewRepository(purchaseState: .readyForPurchase(products: [
        PreviewProduct(),
    ]))
    FooterPurchaseButton(
        selectedOption: .constant(PaywallOption(
            product: PreviewProduct(),
            isTrialEligible: false,
        )),
        purchaseRepository: repository
    )
}
#endif
