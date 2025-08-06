//  Created by Geoff Pado on 5/25/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation
import StoreKit

import FactoryKit

import Defaults
import ErrorHandling
import Logging
import Paywall
import Purchasing

public struct AppRatingsPrompter {
    public init() {
        self.init(
            ratingRequestMethod: SKStoreReviewController.requestReview(in:)
        )
    }

    typealias RatingRequestMethod = @MainActor (UIWindowScene) -> Void
    init(
        ratingRequestMethod: @escaping RatingRequestMethod = SKStoreReviewController.requestReview(in:)
    ) {
        self.ratingRequestMethod = ratingRequestMethod
    }

    @MainActor
    public func displayRatingsPrompt(in windowScene: UIWindowScene?) async {
        guard let windowScene else {
            errorHandler.log(AppRatingsError.missingWindowScene,
                             module: "AppRatings",
                             type: "AppRatingsPrompter")
            return
        }

        let numberOfSaves = defaults.value(for: Keys.numberOfSaves)

        if (numberOfSaves > 0) && (numberOfSaves % Self.ratingNumberOfSavesCadence == 0) {
            ratingRequestMethod(windowScene)
            logger.log(Event(name: .requestedRating, info: [:]))
        } else if numberOfSaves == Self.paywallNumberOfSaves, #available(iOS 16.0, *) {
            guard let topViewController = windowScene.windows.first?.rootViewController,
                  await repository.noOnions != .purchased
            else { return }

            topViewController.present(PaywallHostingController(), animated: true)
        }
    }

    // MARK: Boilerplate

    private static let ratingNumberOfSavesCadence = 3
    private static let paywallNumberOfSaves = 10
    @Injected(\.defaults) private var defaults
    @Injected(\.errorHandler) private var errorHandler
    @Injected(\.logger) private var logger
    private let ratingRequestMethod: RatingRequestMethod
    @Injected(\.purchaseRepository) private var repository
}

private enum AppRatingsError: Error {
    case missingWindowScene
}

extension Event.Name {
    static let requestedRating = Event.Name("AppRatingsPrompter.requestedRating")
}
