//  Created by Geoff Pado on 6/30/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Testing

import PurchasingDoubles
import Purchasing

@testable import Logging
@testable import PurchaseMarketing

struct PurchaseEventBuilderTests {
    @Test func monthlyStart() {
        let option = option(duration: .monthly, isEligibleForTrial: false)
        let eventBuilder = PurchaseEventBuilder()
        let event = eventBuilder.startEvent(for: option)

        #expect(event.value == "Paywall.purchaseStarted")
        #expect(event.info["duration"] == "monthly")
        #expect(event.info["trialEligible"] == "false")
    }

    @Test func annualTrialStart() {
        let option = option(duration: .annual, isEligibleForTrial: true)
        let eventBuilder = PurchaseEventBuilder()
        let event = eventBuilder.startEvent(for: option)

        #expect(event.value == "Paywall.purchaseStarted")
        #expect(event.info["duration"] == "annual")
        #expect(event.info["trialEligible"] == "true")
    }

    @Test func annualNonTrialStart() {
        let option = option(duration: .annual, isEligibleForTrial: false)
        let eventBuilder = PurchaseEventBuilder()
        let event = eventBuilder.startEvent(for: option)

        #expect(event.value == "Paywall.purchaseStarted")
        #expect(event.info["duration"] == "annual")
        #expect(event.info["trialEligible"] == "false")
    }

    private func option(
        duration: PurchaseDuration,
        isEligibleForTrial: Bool
    ) -> PaywallOption {
        PaywallOption(
            product: PreviewProduct(
                duration: duration
            ),
            isTrialEligible: isEligibleForTrial
        )
    }
}
