//  Created by Geoff Pado on 12/4/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Testing

import FactoryKit
import FactoryTesting
import ViewInspector

import LoggingDoubles

@testable import Paywall

@MainActor @Suite(.container)
struct PaywallViewTests {
    @available(iOS 16.0, *)
    @Test func appearanceLoggedOnAppear() throws {
        let logger = SpyLogger()
        Container.shared.logger.register { logger }

        let view = PaywallView()

        try view.inspect().find(ViewType.GeometryReader.self).callOnAppear()

        let matchingEvents = logger.loggedEvents.count { event in
            event.name == .purchaseMarketingDisplayed
        }

        #expect(matchingEvents == 1)
    }
}
