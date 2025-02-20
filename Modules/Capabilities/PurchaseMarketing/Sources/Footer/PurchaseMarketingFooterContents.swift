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
        self.products = products
        _selectedProduct = State(initialValue: products[0])
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
