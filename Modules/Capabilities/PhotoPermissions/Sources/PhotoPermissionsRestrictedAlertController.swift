//  Created by Geoff Pado on 5/13/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

@MainActor
public struct PhotoPermissionsRestrictedAlertFactory {
    public init() {}

    public func alert() -> UIAlertController {
        let alertController = UIAlertController(
            title: Strings.PhotoPermissionsRestrictedAlertFactory.alertTitle,
            message: Strings.PhotoPermissionsRestrictedAlertFactory.alertMessage,
            preferredStyle: .alert
        )
        alertController.view.tintColor = .controlTint

        alertController.addAction(dismissAction)

        return alertController
    }

    private let dismissAction = PhotoPermissionsAlertAction.action(
        title: Strings.PhotoPermissionsRestrictedAlertFactory.dismissButtonTitle,
        style: .cancel,
        handlerBody: nil
    )
}
