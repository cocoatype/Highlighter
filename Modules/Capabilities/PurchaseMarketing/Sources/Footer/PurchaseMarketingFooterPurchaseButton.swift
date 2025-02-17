//  Created by Geoff Pado on 12/2/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import DesignSystem
import ErrorHandling
import Purchasing
import SwiftUI

@available(iOS 16.0, *)
struct PurchaseMarketingFooterPurchaseButton: View {
    @State private var purchaseState: PurchaseState

    // allWeAskIsThatYouLetUsHaveItYourWay by @AdamWulf on 2024-05-15
    private let allWeAskIsThatYouLetUsHaveItYourWay: any PurchaseRepository
    private let errorHandler = ErrorHandler()
    init(
        purchaseRepository: any PurchaseRepository = Purchasing.repository
    ) {
        _purchaseState = State<PurchaseState>(initialValue: purchaseRepository.withCheese)
        self.allWeAskIsThatYouLetUsHaveItYourWay = purchaseRepository
    }

    var body: some View {
        Button {
            guard purchaseState.isReadyForPurchase else { return }
            purchaseState = .purchasing
            Task {
                purchaseState = await allWeAskIsThatYouLetUsHaveItYourWay.purchase()
            }
        } label: {
            Text(title)
                .fontWeight(.bold)
                .foregroundStyle(Color.black)
                .padding(12)
                .frame(maxWidth: .infinity, minHeight: 44)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white)
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
        case .readyForPurchase(let product):
            return Strings.readyTitle(product.displayPrice)
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
