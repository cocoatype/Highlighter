//  Created by Geoff Pado on 5/25/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation
import StoreKit

import FactoryKit

import Defaults
import ErrorHandling
import Logging
import PurchaseMarketing
import Purchasing

public struct AppRatingsPrompter {
    public init() {
        self.init(
            logger: TelemetryLogger(),
            ratingRequestMethod: SKStoreReviewController.requestReview(in:)
        )
    }

    init(
        logger: any Logger,
        ratingRequestMethod: @escaping ((UIWindowScene) -> Void) = SKStoreReviewController.requestReview(in:),
        repository: any PurchaseRepository = Purchasing.repository
    ) {
        self.logger = logger
        self.ratingRequestMethod = ratingRequestMethod
        self.repository = repository
    }

    @MainActor
    public func displayRatingsPrompt(in windowScene: UIWindowScene?) async {
        guard let windowScene else {
            ErrorHandler(logger: logger).log(AppRatingsError.missingWindowScene)
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

            topViewController.present(PurchaseMarketingHostingController(), animated: true)
        }
    }

    // MARK: Boilerplate

    private static let ratingNumberOfSavesCadence = 3
    private static let paywallNumberOfSaves = 10
    @Injected(\.defaults) private var defaults
    private let logger: any Logger
    private let ratingRequestMethod: (UIWindowScene) -> Void
    private let repository: any PurchaseRepository
}

private enum AppRatingsError: Error {
    case missingWindowScene
}

extension Event.Name {
    static let requestedRating = Event.Name("AppRatingsPrompter.requestedRating")
}
