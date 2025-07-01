//  Created by Geoff Pado on 12/2/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Purchasing
import SwiftUI

@available(iOS 16.0, *)
struct PurchaseMarketingFooterContents: View {
    @State private var selectedOption: PaywallOption
    private let options: [PaywallOption]
    init(
        options: [PaywallOption]
    ) {
        self.options = options.sorted(by: { lhs, rhs in
            lhs.price < rhs.price
        })
        let selectedOption = options.first { $0.duration == .annual } ?? options[0]
        _selectedOption = State(initialValue: selectedOption)
    }

    var body: some View {
        VStack(spacing: 20) {
            PurchaseMarketingDurationPicker(
                options: options,
                selectedOption: $selectedOption
            )
            PurchaseMarketingFooterPurchaseButton(
                selectedOption: $selectedOption
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
        PurchaseMarketingFooterContents(
            options: [
                PreviewProduct(displayName: "One-Time", price: 19.99, duration: .oneTime),
                PreviewProduct(displayName: "Monthly", price: 0.99, duration: .monthly),
                PreviewProduct(displayName: "Annual", price: 4.99, duration: .annual),
            ].map { PaywallOption(product: $0, isTrialEligible: false) }
        ).background(Color(uiColor: .appBackground))
    }
}
#endif
