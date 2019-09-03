//  Created by Geoff Pado on 4/13/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PhotoPermissionsDeniedAlertFactory: NSObject {
    static func alert() -> PhotoPermissionsDeniedAlertController {
        let alertController = PhotoPermissionsDeniedAlertController(title: PhotoPermissionsDeniedAlertFactory.alertTitle, message: PhotoPermissionsDeniedAlertFactory.alertMessage, preferredStyle: .alert)
        alertController.view.tintColor = .controlTint

        alertController.addAction(settingsAction)

        return alertController
    }

    private static let settingsAction = UIAlertAction(title: PhotoPermissionsDeniedAlertFactory.actionButtonTitle, style: .default, handler: { _ in
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL)
    })
    private static let cancelAction = UIAlertAction(title: PhotoPermissionsDeniedAlertFactory.cancelButtonTitle, style: .cancel, handler: nil)

    // MARK: Localized Strings

    private static let alertTitle = NSLocalizedString("PhotoPermissionsDeniedAlertController.alertTitle", comment: "Title for the photo permissions denied alert")
    private static let alertMessage = NSLocalizedString("PhotoPermissionsDeniedAlertController.alertMessage", comment: "Message for the photo permissions denied alert")
    private static let actionButtonTitle = NSLocalizedString("PhotoPermissionsDeniedAlertController.actionButtonTitle", comment: "Title for the settings button on the photo permissions denied alert")
    private static let cancelButtonTitle = NSLocalizedString("PhotoPermissionsDeniedAlertController.cancelButtonTitle", comment: "Title for the cancel button on the photo permissions denied alert")
}

class PhotoPermissionsDeniedAlertController: UIAlertController {}
