//  Created by Geoff Pado on 12/4/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import LoggingDoubles
import ViewInspector
import XCTest

@testable import PurchaseMarketing

@available(iOS 16.0, *)
final class PurchaseMarketingTests: XCTestCase {
    func testWhenOnAppearThenAppearanceLogged() throws {
        let logger = SpyLogger()
        let view = PurchaseMarketingView(
            purchaseState: .constant(.loading),
            logger: logger
        )

        try view.inspect().implicitAnyView().geometryReader().callOnAppear()

        let matchingEvents = logger.loggedEvents.count { event in
            event.name == .purchaseMarketingDisplayed
        }

        XCTAssertEqual(matchingEvents, 1)
    }
}
