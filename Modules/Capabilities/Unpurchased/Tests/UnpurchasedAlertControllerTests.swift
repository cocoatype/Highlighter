//  Created by Geoff Pado on 12/4/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Testing

import FactoryKit
import FactoryTesting

import LoggingDoubles

@testable import Unpurchased

@MainActor @Suite(.container)
struct UnpurchasedAlertControllerTests {
    @Test @available(iOS 18.0, *)
    func viewDidAppear() {
        let logger = SpyLogger()
        Container.shared.logger.register { logger }

        let alertController = UnpurchasedAlertController()
        alertController.viewDidAppear(false)

        let containsExpectedEvent = logger.loggedEvents.contains {
            $0.name == "UnpurchasedAlertController.viewDidAppear"
        }
        #expect(containsExpectedEvent == true)
    }
}
