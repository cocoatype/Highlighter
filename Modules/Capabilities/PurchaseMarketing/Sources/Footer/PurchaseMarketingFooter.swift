//  Created by Geoff Pado on 12/2/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import ErrorHandling
import Purchasing
import SwiftUI

@available(iOS 16.0, *)
struct PurchaseMarketingFooter: View {
    @State private var viewState: ViewState = .loading
    private let errorHandler: ErrorHandler
    private let purchaseRepository: any PurchaseRepository
    init(
        errorHandler: ErrorHandler = ErrorHandler(),
        purchaseRepository: any PurchaseRepository = Purchasing.repository
    ) {
        self.errorHandler = errorHandler
        self.purchaseRepository = purchaseRepository
    }

    var body: some View {
        Group {
            switch viewState {
            case .loading:
                ProgressView()
            case .unpurchased(let products):
                PurchaseMarketingFooterContents(products: products)
            }
        }.task {
            if let products = try? await purchaseRepository.products {
                viewState = .unpurchased(products)
            }
        }
    }

    enum ViewState {
        case loading
        case unpurchased([any PurchaseProduct])
    }
}

#if DEBUG
import PurchasingDoubles
@available(iOS 16.0, *)
enum PurchaseMarketingFooterPreviews: PreviewProvider {
    static var previews: some View {
        PurchaseMarketingFooter(purchaseRepository: PreviewRepository(purchaseState: .readyForPurchase(products: [
            PreviewProduct(),
        ])))
    }
}
#endif
