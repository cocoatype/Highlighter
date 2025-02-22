//  Created by Geoff Pado on 12/2/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Purchasing
import SwiftUI

@available(iOS 16.0, *)
struct PurchaseMarketingFooterContents: View {
    @State private var selectedProduct: any PurchaseProduct
    private let products: [any PurchaseProduct]
    init(
        products: [any PurchaseProduct]
    ) {
        self.products = products.sorted(by: { lhs, rhs in
            lhs.price < rhs.price
        })
        let selectedProduct = products.first { $0.duration == .annual } ?? products[0]
        _selectedProduct = State(initialValue: selectedProduct)
    }

    var body: some View {
        VStack(spacing: 20) {
            PurchaseMarketingDurationPicker(
                products: products,
                selectedProduct: $selectedProduct
            )
            PurchaseMarketingFooterPurchaseButton(
                selectedProduct: $selectedProduct
            )
            PurchaseMarketingFooterLinkSection()
        }.padding()
    }
}

#if DEBUG
import PurchasingDoubles
@available(iOS 16.0, *)
enum PurchaseMarketingFooterContentsPreviews: PreviewProvider {
    static var previews: some View {
        PurchaseMarketingFooterContents(products: [
            PreviewProduct(displayName: "One-Time", price: 19.99, duration: .oneTime),
            PreviewProduct(displayName: "Monthly", price: 0.99, duration: .monthly),
            PreviewProduct(displayName: "Annual", price: 4.99, duration: .annual),
        ]).background(Color(uiColor: .appBackground))
    }
}
#endif
