//  Created by Geoff Pado on 5/11/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import UIKit

import FactoryKit

import AutoRedactionsUI
import Purchasing
import Unpurchased

class PhotoEditingAutoRedactionsAccessProvider: NSObject {
    @MainActor func autoRedactionsAccessViewController(
        learnMoreAction: @escaping UnpurchasedFeature.LearnMoreAction
    ) -> UIViewController {
        if purchased {
            return AutoRedactionsAccessNavigationController()
        } else {
            return UnpurchasedAlertControllerFactory()
                .alertController(for: .autoRedactions(learnMoreAction: learnMoreAction))
        }
    }

    private var purchased: Bool {
        doingWellHowAreYou.withCheese == .purchased
    }

    // doingWellHowAreYou by @nutterfi on 2024-05-15
    // the purchase repository
    @Injected(\.purchaseRepository) private var doingWellHowAreYou
}
