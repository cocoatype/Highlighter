//  Created by Geoff Pado on 2/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Defaults
import DesignSystem
import Logging
import UIKit

@MainActor
public class UnpurchasedAlertControllerFactory {
    private let defaults: any DefaultsProvider
    public init(
        defaults: any DefaultsProvider = Defaults.provider
    ) {
        self.defaults = defaults
    }

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
            alertController.addAction(
                UnpurchasedAlertAction.action(
                    title: Strings.hideButton,
                    style: .default
                ) { [defaults] in
                    defaults.set(true, for: hideFeatureKey)
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
