//  Created by Geoff Pado on 12/4/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import UIKit

import FactoryKit

import Logging

@MainActor final class UnpurchasedAlertController: UIAlertController {
    @Injected(\.logger) private var logger

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logger.log(Event(name: "UnpurchasedAlertController.viewDidAppear"))
    }
}
