//  Created by Geoff Pado on 5/25/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import Foundation
import StoreKit

class AppRatingsPrompter: NSObject {
    init(requestMethod: @escaping ((UIWindowScene) -> Void) = SKStoreReviewController.requestReview(in:)) {
        self.requestMethod = requestMethod
    }

    func displayRatingsPrompt(in windowScene: UIWindowScene?) {
        guard let windowScene = windowScene,
              Defaults.numberOfSaves >= Self.minNumberOfSaves
        else { return }

        requestMethod(windowScene)
    }

    // MARK: Boilerplate

    private static let minNumberOfSaves = 3
    private let requestMethod: (UIWindowScene) -> Void
}
