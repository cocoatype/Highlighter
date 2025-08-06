//  Created by Geoff Pado on 7/10/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import SwiftUI

import DesignSystem

struct PaywallOptionDescription: View {
    private let option: PaywallOption
    init(_ option: PaywallOption) {
        self.option = option
    }

    var body: some View {
        if let description {
            Text(description)
                .multilineTextAlignment(.center)
                .font(.app(textStyle: .subheadline))
        }
    }

    private var description: String? {
        switch option.duration {
        case .monthly:
            return Strings.Monthly.message(option.displayPrice)
        case .annual where option.isTrialEligible:
            return Strings.YearlyWithTrial.message(option.displayPrice)
        case .annual:
            return Strings.Yearly.message(option.displayPrice)
        case .oneTime:
            return Strings.OneTime.message(option.displayPrice)
        case .unknown:
            return nil
        }
    }

    private typealias Strings = PaywallStrings.PaywallOption
}

#if DEBUG
import PurchasingDoubles
#Preview {
    let products = [
        StubProduct(price: 0.99, duration: .monthly),
        StubProduct(price: 4.99, duration: .annual),
        StubProduct(price: 4.99, duration: .annual, isTrialEligible: true),
        StubProduct(price: 14.99, duration: .oneTime),
    ]
    ForEach(products) { product in
        PaywallOptionDescription(
            PaywallOption(
                product: product,
                isTrialEligible: product.isTrialEligible
            )
        )
    }
}
#endif
