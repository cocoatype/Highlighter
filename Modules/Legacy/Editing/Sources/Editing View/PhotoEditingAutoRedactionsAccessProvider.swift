//  Created by Geoff Pado on 5/11/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import AutoRedactionsUI
import Purchasing
import UIKit
import Unpurchased

class PhotoEditingAutoRedactionsAccessProvider: NSObject {
    init(
        purchaseRepository: any PurchaseRepository = Purchasing.repository
    ) {
        doingWellHowAreYou = purchaseRepository
    }

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
    private let doingWellHowAreYou: any PurchaseRepository
}
