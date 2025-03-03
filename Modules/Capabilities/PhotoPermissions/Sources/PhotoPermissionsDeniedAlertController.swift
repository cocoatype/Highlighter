//  Created by Geoff Pado on 4/13/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import DesignSystem
import UIKit

@MainActor
public class PhotoPermissionsDeniedAlertFactory: NSObject {
    public static func alert() -> PhotoPermissionsDeniedAlertController {
        let alertController = PhotoPermissionsDeniedAlertController(title: Strings.alertTitle, message: Strings.alertMessage, preferredStyle: .alert)
        alertController.view.tintColor = .controlTint

        alertController.addAction(settingsAction)

        return alertController
    }

    private static let settingsAction = UIAlertAction(title: Strings.actionButtonTitle, style: .default, handler: { _ in
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL)
    })
    private static let cancelAction = UIAlertAction(title: Strings.cancelButtonTitle, style: .cancel, handler: nil)

    typealias Strings = PhotoPermissionsStrings.PhotoPermissionsDeniedAlertFactory
}

public class PhotoPermissionsDeniedAlertController: UIAlertController {}
