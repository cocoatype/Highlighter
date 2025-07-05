//  Created by Geoff Pado on 6/30/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Testing

import FactoryKit
import FactoryTesting

import LoggingDoubles
import Purchasing
import PurchasingDoubles

@testable import Logging
@testable import Paywall

@MainActor @Suite(.container)
struct PurchaserTests {
    @available(iOS 18.0, *)
    @Test("Making purchase sends purchase started log")
    func purchaseStartedLog() async throws {
        let logger = SpyLogger()
        Container.shared.logger.register { logger }
        _ = try await Purchaser(
            repository: SpyRepository()
        ).purchase(
            PaywallOption(
                product: PreviewProduct(
                    duration: .monthly
                ),
                isTrialEligible: false
            )
        )

        #expect(logger.loggedEvents.count == 1)
        let event = try #require(logger.loggedEvents.first)
        #expect(event.value == "Paywall.purchaseStarted")
    }
}
