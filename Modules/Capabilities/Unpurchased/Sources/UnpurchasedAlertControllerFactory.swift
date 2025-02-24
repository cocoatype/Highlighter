//  Created by Geoff Pado on 2/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Defaults
import DesignSystem
import Logging
import UIKit

public class UnpurchasedAlertControllerFactory {
    public init() {}

    public func alertController(for feature: UnpurchasedFeature) -> UIAlertController {
        let alertController = UnpurchasedAlertController(
            title: Strings.title,
            message: feature.message,
            preferredStyle: .alert
        )

        alertController.view.tintColor = .controlTint

        if let learnMoreAction = feature.learnMoreAction {
            alertController.addAction(
                UnpurchasedAlertAction.action(
                    title: Strings.learnMoreButton,
                    style: .default
                ) {
                    learnMoreAction()
                }
            )
        }

        if let hideFeatureKey = feature.hideFeatureKey {
            @Defaults.Value(key: hideFeatureKey) var hideFeature: Bool
            alertController.addAction(
                UnpurchasedAlertAction.action(
                    title: Strings.hideButton,
                    style: .default
                ) {
                    hideFeature = true
                }
            )
        }

        alertController.addAction(
            UnpurchasedAlertAction.action(
                title: Strings.dismissButton,
                style: .cancel
            ) {}
        )

        return alertController
    }

    private typealias Strings = UnpurchasedStrings.UnpurchasedAlert
}
