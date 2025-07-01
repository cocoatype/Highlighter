//  Created by Geoff Pado on 6/30/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Logging
import Purchasing

struct PurchaseEventBuilder {
    func startEvent(for option: PaywallOption) -> Event {
        Event(
            name: "Paywall.purchaseStarted",
            info: [
                "duration": durationInfo(for: option),
                "trialEligible": trialInfo(for: option)
            ]
        )
    }

    private func durationInfo(for option: PaywallOption) -> String {
        switch option.duration {
        case .annual: "annual"
        case .monthly: "monthly"
        case .oneTime: "oneTime"
        case .unknown: "unknown"
        }
    }

    private func trialInfo(for option: PaywallOption) -> String {
        option.isTrialEligible.description
    }
}
