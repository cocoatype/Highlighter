//  Created by Geoff Pado on 5/25/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import Foundation
import StoreKit

class AppRatingsPrompter: NSObject {
    static func displayRatingsPrompt(in windowScene: UIWindowScene?) {
        guard let windowScene = windowScene else { return }
        if triggeringNumberOfSaves.contains(Defaults.numberOfSaves) {
            if #available(iOS 14.0, *) {
                SKStoreReviewController.requestReview(in: windowScene)
            } else {
                SKStoreReviewController.requestReview()
            }
        }
    }

    // MARK: Boilerplate

    static let triggeringNumberOfSaves = [3, 10, 30]
}
