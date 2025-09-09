//  Created by Geoff Pado on 8/4/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

import DesignSystem

@MainActor class PageCountAlertFactory: NSObject {
    static func alert(completionHandler: @escaping (@MainActor () -> Void)) -> UIAlertController {
        let alertController = UIAlertController(
            title: Strings.PageCountAlertFactory.alertTitle,
            message: Strings.PageCountAlertFactory.alertMessage,
            preferredStyle: .alert
        )
        alertController.view.tintColor = .controlTint

        let dismissAction = UIAlertAction(
            title: Strings.PageCountAlertFactory.dismissButtonTitle,
            style: .default,
            handler: { _ in completionHandler() }
        )
        alertController.addAction(dismissAction)

        return alertController
    }
}
