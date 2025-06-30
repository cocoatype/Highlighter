//  Created by Geoff Pado on 5/16/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import DefaultsDoubles
import DesignSystemDoubles
import LoggingDoubles
import PurchasingDoubles
import TestHelpers
import XCTest

@testable import Core

class AppDelegateTests: XCTestCase {
    @MainActor func testWillFinishLaunchingCallsStartOnPurchaseRepository() {
        let repository = SpyRepository(startExpectation: expectation(description: "start called"))
        let logger = SpyLogger()
        let delegate = AppDelegate(
            defaults: StubDefaultsProvider(),
            purchaseRepository: repository,
            logger: logger,
            appearanceWriter: StubAppearanceWriter()
        )

        _ = delegate.application(UIApplication.shared, willFinishLaunchingWithOptions: nil)

        waitForExpectations(timeout: 1)
    }
}
