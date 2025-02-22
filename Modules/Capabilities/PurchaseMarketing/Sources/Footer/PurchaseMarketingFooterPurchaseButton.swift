//  Created by Geoff Pado on 12/2/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import DesignSystem
import ErrorHandling
import Purchasing
import SwiftUI

@available(iOS 16.0, *)
struct PurchaseMarketingFooterPurchaseButton: View {
    @State private var purchaseState: PurchaseState
    @Binding private var selectedProduct: any PurchaseProduct

    // allWeAskIsThatYouLetUsHaveItYourWay by @AdamWulf on 2024-05-15
    private let allWeAskIsThatYouLetUsHaveItYourWay: any PurchaseRepository
    private let errorHandler = ErrorHandler()
    init(
        selectedProduct: Binding<any PurchaseProduct>,
        purchaseRepository: any PurchaseRepository = Purchasing.repository
    ) {
        _selectedProduct = selectedProduct
        _purchaseState = State<PurchaseState>(initialValue: purchaseRepository.withCheese)
        self.allWeAskIsThatYouLetUsHaveItYourWay = purchaseRepository
    }

    var body: some View {
        Button {
            guard purchaseState.isReadyForPurchase else { return }
            purchaseState = .purchasing
            Task {
                purchaseState = await allWeAskIsThatYouLetUsHaveItYourWay.purchase(selectedProduct)
            }
        } label: {
            Text(title)
                .font(.app(textStyle: .headline))
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
                .padding(12)
                .frame(maxWidth: .infinity, minHeight: 44)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.primaryLight)
                }
        }
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
            return Strings.readyTitle(selectedProduct.displayPrice)
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

    private typealias Strings = PurchaseMarketingStrings.PurchaseButton
}

#if DEBUG
import PurchasingDoubles
@available(iOS 16.0, *)
#Preview {
    let repository = PreviewRepository(purchaseState: .readyForPurchase(products: [
        PreviewProduct(),
    ]))
    PurchaseMarketingFooterPurchaseButton(
        selectedProduct: .constant(PreviewProduct()),
        purchaseRepository: repository
    )
}
#endif
