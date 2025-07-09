//  Created by Geoff Pado on 5/16/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Testing

import FactoryKit
import FactoryTesting

import DefaultsDoubles
import DesignSystemDoubles
import LoggingDoubles
import PurchasingDoubles
import TestHelpers

@testable import Core

@MainActor @Suite(.container)
struct AppDelegateTests {
    @Test func willFinishLaunchingCallsStartOnPurchaseRepository() async {
        await confirmation { confirmation in
            Container.shared.defaults.register { @MainActor in StubDefaultsProvider() }
            Container.shared.logger.register { SpyLogger() }
            Container.shared.purchaseRepository.register {
                SpyRepository(startExpectation: confirmation)
            }
            let delegate = AppDelegate(
                appearanceWriter: StubAppearanceWriter()
            )

            _ = delegate.application(UIApplication.shared, willFinishLaunchingWithOptions: nil)
        }
    }
}
