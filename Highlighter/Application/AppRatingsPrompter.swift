//  Created by Geoff Pado on 5/25/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import Foundation
import StoreKit

class AppRatingsPrompter: NSObject {
    static func displayRatingsPrompt(in windowScene: UIWindowScene?) {
        guard let windowScene = windowScene else { return }
        let numberOfSaves = Defaults.numberOfSaves % 50
        if triggeringNumberOfSaves.contains(numberOfSaves) {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }

    // MARK: Boilerplate

    static let triggeringNumberOfSaves = [3, 10, 30]
    private static let wraparound = 50
}
