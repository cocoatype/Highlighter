//  Created by Geoff Pado on 12/4/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import LoggingDoubles
import ViewInspector
import Testing

@testable import PurchaseMarketing

@MainActor
struct PurchaseMarketingTests {
    @available(iOS 16.0, *)
    @Test func appearanceLoggedOnAppear() throws {
        let logger = SpyLogger()
        let view = PurchaseMarketingView(
            purchaseState: .constant(.loading),
            logger: logger
        )

        try view.inspect().find(ViewType.GeometryReader.self).callOnAppear()

        let matchingEvents = logger.loggedEvents.count { event in
            event.name == .purchaseMarketingDisplayed
        }

        #expect(matchingEvents == 1)
    }
}
