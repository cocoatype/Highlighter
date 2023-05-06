//  Created by Geoff Pado on 5/25/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Defaults
import Foundation
import StoreKit

public struct AppRatingsPrompter {
    public init() {
        self.init(requestMethod: SKStoreReviewController.requestReview(in:))
    }

    init(requestMethod: @escaping ((UIWindowScene) -> Void) = SKStoreReviewController.requestReview(in:)) {
        self.requestMethod = requestMethod
    }

    public func displayRatingsPrompt(in windowScene: UIWindowScene?) {
        guard let windowScene = windowScene,
              Defaults.numberOfSaves >= Self.minNumberOfSaves
        else { return }

        requestMethod(windowScene)
    }

    // MARK: Boilerplate

    private static let minNumberOfSaves = 3
    private let requestMethod: (UIWindowScene) -> Void
}
