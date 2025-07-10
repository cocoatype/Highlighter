//  Created by Geoff Pado on 7/10/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import SwiftUI

import DesignSystem

struct DurationPickerItem: View {
    private let option: PaywallOption
    init(option: PaywallOption) {
        self.option = option
    }

    var body: some View {
        if let shortName {
            Text(shortName)
                .font(.app(textStyle: .footnote))
                .tag(option)
        }
    }

    private var shortName: String? {
        switch option.duration {
        case .monthly:
            return Strings.Monthly.shortName
        case .annual where option.isTrialEligible:
            return Strings.YearlyWithTrial.shortName
        case .annual:
            return Strings.Yearly.shortName
        case .oneTime:
            return Strings.OneTime.shortName
        case .unknown:
            return nil
        }
    }

    private typealias Strings = PaywallStrings.PaywallOption
}
