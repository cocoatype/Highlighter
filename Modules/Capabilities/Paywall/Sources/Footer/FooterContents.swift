//  Created by Geoff Pado on 12/2/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Purchasing
import SwiftUI

@available(iOS 16.0, *)
struct FooterContents: View {
    @State private var selectedOption: PaywallOption?
    private let options: [PaywallOption]
    init(
        options: [PaywallOption]
    ) {
        self.options = options.sorted(by: { lhs, rhs in
            lhs.price < rhs.price
        })
        let selectedOption = options.first { $0.duration == .annual }
        _selectedOption = State(initialValue: selectedOption)
    }

    var body: some View {
        VStack(spacing: 20) {
                DurationPicker(
                    options: options,
                    selectedOption: $selectedOption
                )
            VStack(spacing: 8) {
                if let selectedOption {
                    PaywallOptionDescription(selectedOption)
                }
                FooterPurchaseButton(
                    selectedOption: selectedOption
                )
            }
            FooterLinkSection()
        }.padding()
    }
}

#if DEBUG
import PurchasingDoubles
@available(iOS 16.0, *)
enum PurchaseMarketingFooterContentsPreviews: PreviewProvider {
    static var previews: some View {
        Color.black.ignoresSafeArea()
            .safeAreaInset(edge: .bottom) {
                FooterContents(
                    options: [
                        StubProduct(displayName: "One-Time", price: 14.99, duration: .oneTime),
                        StubProduct(displayName: "Monthly", price: 0.99, duration: .monthly),
                        StubProduct(displayName: "Annual", price: 4.99, duration: .annual),
                    ].map { PaywallOption(product: $0, isTrialEligible: false) }
                ).background(Color(uiColor: .appBackground), ignoresSafeAreaEdges: .bottom)
            }
    }
}
#endif
