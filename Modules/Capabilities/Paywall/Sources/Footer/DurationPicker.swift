//  Created by Geoff Pado on 10/15/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import DesignSystem
import Purchasing
import SwiftUI

struct DurationPicker: View {
    @Binding private var selectedOption: PaywallOption
    private let options: [PaywallOption]

    init(
        options: [PaywallOption],
        selectedOption: Binding<PaywallOption>
    ) {
        self.options = options
        _selectedOption = selectedOption
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
                .font: UIFont.appFont(forTextStyle: .caption1),
            ], for: .normal)
        })
    }
}

#if DEBUG
import PurchasingDoubles
#Preview {
    DurationPicker(
        options: [
            PreviewProduct(),
            PreviewProduct(),
        ].map { PaywallOption(product: $0, isTrialEligible: false) },
        selectedOption: .constant(
            PaywallOption(product: PreviewProduct(), isTrialEligible: false),
        )
    )
}
#endif
