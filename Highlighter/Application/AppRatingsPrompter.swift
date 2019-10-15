//  Created by Geoff Pado on 5/25/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import Foundation
import StoreKit

class AppRatingsPrompter: NSObject {
    static func displayRatingsPrompt() {
        if triggeringNumberOfSaves.contains(Defaults.numberOfSaves) {
            SKStoreReviewController.requestReview()
        }
    }

    // MARK: Boilerplate

    static let triggeringNumberOfSaves = [3, 10, 30]
}
