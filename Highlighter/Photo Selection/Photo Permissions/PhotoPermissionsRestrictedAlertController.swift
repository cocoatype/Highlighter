//  Created by Geoff Pado on 5/13/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PhotoPermissionsRestrictedAlertFactory: NSObject {
    static func alert() -> PhotoPermissionsRestrictedAlertController {
        let alertController = PhotoPermissionsRestrictedAlertController(title: PhotoPermissionsRestrictedAlertFactory.alertTitle, message: PhotoPermissionsRestrictedAlertFactory.alertMessage, preferredStyle: .alert)
        alertController.view.tintColor = .controlTint

        alertController.addAction(dismissAction)

        return alertController
    }

    private static let dismissAction = UIAlertAction(title: PhotoPermissionsRestrictedAlertFactory.dismissButtonTitle, style: .cancel, handler: nil)

    // MARK: Localized Strings

    private static let alertTitle = NSLocalizedString("PhotoPermissionsRestrictedAlertController.alertTitle", comment: "Title for the photo permissions restricted alert")
    private static let alertMessage = NSLocalizedString("PhotoPermissionsRestrictedAlertController.alertMessage", comment: "Message for the photo permissions restricted alert")
    private static let dismissButtonTitle = NSLocalizedString("PhotoPermissionsRestrictedAlertController.dismissButtonTitle", comment: "Title for the cancel button on the photo permissions restricted alert")
}

class PhotoPermissionsRestrictedAlertController: UIAlertController {}
