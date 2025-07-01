//  Created by Geoff Pado on 12/2/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import ErrorHandling
import Purchasing
import SwiftUI

@available(iOS 16.0, *)
struct Footer: View {
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
        currentView
            .task { await updateProducts() }
    }

    private func updateProducts() async {
        do {
            let products = try await purchaseRepository.products
            let options = await withTaskGroup(of: PaywallOption.self) { group in
                for product in products {
                    group.addTask {
                        return await PaywallOption(product: product)
                    }
                }

                var options = [PaywallOption]()
                for await option in group {
                    options.append(option)
                }
                return options
            }
            viewState = .unpurchased(options)
        } catch {
            errorHandler.log(error)
        }
    }

    @ViewBuilder private var currentView: some View {
        switch viewState {
        case .loading:
            ProgressView()
        case .unpurchased(let options):
            FooterContents(options: options)
        }
    }

    enum ViewState {
        case loading
        case unpurchased([PaywallOption])
    }
}

#if DEBUG
import PurchasingDoubles
@available(iOS 16.0, *)
enum PurchaseMarketingFooterPreviews: PreviewProvider {
    static var previews: some View {
        Footer(purchaseRepository: PreviewRepository(purchaseState: .readyForPurchase(products: [
            PreviewProduct(),
        ])))
    }
}
#endif
