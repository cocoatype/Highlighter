//  Created by Geoff Pado on 5/25/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Defaults
import ErrorHandling
import Logging
import Foundation
import StoreKit

public struct AppRatingsPrompter {
    public init() {
        self.init(logger: TelemetryLogger(), requestMethod: SKStoreReviewController.requestReview(in:))
    }

    init(logger: Logger, requestMethod: @escaping ((UIWindowScene) -> Void) = SKStoreReviewController.requestReview(in:)) {
        self.logger = logger
        self.requestMethod = requestMethod
    }

    public func displayRatingsPrompt(in windowScene: UIWindowScene?) {
        guard let windowScene else {
            ErrorHandler(logger: logger).log(AppRatingsError.missingWindowScene)
            return
        }

        guard Defaults.numberOfSaves >= Self.minNumberOfSaves
        else { return }

        requestMethod(windowScene)
        logger.log(Event(name: .requestedRating, info: [:]))
    }

    // MARK: Boilerplate

    private static let minNumberOfSaves = 3
    private let logger: Logger
    private let requestMethod: (UIWindowScene) -> Void
}

private enum AppRatingsError: Error {
    case missingWindowScene
}

extension Event.Name {
    static let requestedRating = Event.Name("AppRatingsPrompter.requestedRating")
}
