//  Created by Geoff Pado on 10/15/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import DesignSystem
import Purchasing
import SwiftUI

struct PurchaseMarketingDurationPicker: View {
    @State private var selectedOption: PurchaseOption
    @Binding private var selectedProduct: any PurchaseProduct
    private let options: [PurchaseOption]

    init(
        products: [any PurchaseProduct],
        selectedProduct: Binding<any PurchaseProduct>
    ) {
        self.options = products.map(PurchaseOption.init)
        _selectedProduct = selectedProduct
        selectedOption = options.first(where: {
            $0.id == selectedProduct.wrappedValue.id
        }) ?? options[0] // shut up, I hate it too
    }

    var body: some View {
        Picker(selection: $selectedOption) {
            ForEach(options) { option in
                Text(option.product.displayName)
                    .tag(option)
            }
        } label: {
            Text("Purchase Option")
        }
        .pickerStyle(.segmented)
        .introspect(.picker(style: .segmented), on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18), customize: { segmentedControl in
            segmentedControl.backgroundColor = .primary
            segmentedControl.selectedSegmentTintColor = .primaryLight
            segmentedControl.setTitleTextAttributes([
                .foregroundColor: UIColor.white,
                .font: UIFont.appFont(forTextStyle: .caption1)
            ], for: .normal)
            print(segmentedControl)
        })
        .onChange(of: selectedOption) {
            selectedProduct = $0.product
        }
    }

    struct PurchaseOption: Hashable, Identifiable {
        let product: any PurchaseProduct
        var id: String { product.id }

        static func == (lhs: PurchaseOption, rhs: PurchaseOption) -> Bool {
            return lhs.id == rhs.product.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
}

#if DEBUG
import PurchasingDoubles
#Preview {
    PurchaseMarketingDurationPicker(
        products: [
            PreviewProduct(),
            PreviewProduct(),
//            PaywallPurchaseOption(currantLocation: PurchaseOption(duration: .monthly, price: 13, currency: "GBP", isEligibleForTrial: false, productIdentifier: "")),
//            PaywallPurchaseOption(currantLocation: PurchaseOption(duration: .annual, price: 42, currency: "CAD", isEligibleForTrial: true, productIdentifier: "")),
        ],
        selectedProduct: .constant(
            PreviewProduct()
//            PaywallPurchaseOption(currantLocation: PurchaseOption(duration: .annual, price: 1972, currency: "NZD", isEligibleForTrial: true, productIdentifier: ""))
        )
    )
}
#endif
