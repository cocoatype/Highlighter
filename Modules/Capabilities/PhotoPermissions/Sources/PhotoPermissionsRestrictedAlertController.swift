//  Created by Geoff Pado on 5/13/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

@MainActor
public class PhotoPermissionsRestrictedAlertFactory: NSObject {
    public static func alert() -> PhotoPermissionsRestrictedAlertController {
        let alertController = PhotoPermissionsRestrictedAlertController(title: Strings.alertTitle, message: Strings.alertMessage, preferredStyle: .alert)
        alertController.view.tintColor = .controlTint

        alertController.addAction(dismissAction)

        return alertController
    }

    private static let dismissAction = UIAlertAction(title: Strings.dismissButtonTitle, style: .cancel, handler: nil)

    private typealias Strings = PhotoPermissionsStrings.PhotoPermissionsRestrictedAlertFactory
}

public class PhotoPermissionsRestrictedAlertController: UIAlertController {}
