//  Created by Geoff Pado on 4/13/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PhotoPermissionsDeniedAlertController: UIAlertController {
    init() {
        super.init(nibName: nil, bundle: nil)

        title = PhotoPermissionsDeniedAlertController.alertTitle
        message = PhotoPermissionsDeniedAlertController.alertMessage

        addAction(settingsAction)
        addAction(cancelAction)
    }

    private let settingsAction = UIAlertAction(title: PhotoPermissionsDeniedAlertController.actionButtonTitle, style: .default, handler: { _ in
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL)
    })
    private let cancelAction = UIAlertAction(title: PhotoPermissionsDeniedAlertController.cancelButtonTitle, style: .cancel, handler: nil)

    // MARK: Boilerplate

    override var preferredStyle: UIAlertController.Style { return .alert }

    private static let alertTitle = NSLocalizedString("PhotoPermissionsDeniedAlertController.alertTitle", comment: "Title for the photo permissions denied alert")
    private static let alertMessage = NSLocalizedString("PhotoPermissionsDeniedAlertController.alertMessage", comment: "Message for the photo permissions denied alert")
    private static let actionButtonTitle = NSLocalizedString("PhotoPermissionsDeniedAlertController.actionButtonTitle", comment: "Title for the settings button on the photo permissions denied alert")
    private static let cancelButtonTitle = NSLocalizedString("PhotoPermissionsDeniedAlertController.cancelButtonTitle", comment: "Title for the cancel button on the photo permissions denied alert")

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

class PhotoPermissionsRestrictedAlertController: UIAlertController {
    init() {
        super.init(nibName: nil, bundle: nil)

        title = PhotoPermissionsRestrictedAlertController.alertTitle
        message = PhotoPermissionsRestrictedAlertController.alertMessage

        addAction(dismissAction)
    }

    private let dismissAction = UIAlertAction(title: PhotoPermissionsRestrictedAlertController.dismissButtonTitle, style: .cancel, handler: nil)

    // MARK: Boilerplate

    override var preferredStyle: UIAlertController.Style { return .alert }

    private static let alertTitle = NSLocalizedString("PhotoPermissionsRestrictedAlertController.alertTitle", comment: "Title for the photo permissions restricted alert")
    private static let alertMessage = NSLocalizedString("PhotoPermissionsRestrictedAlertController.alertMessage", comment: "Message for the photo permissions restricted alert")
    private static let dismissButtonTitle = NSLocalizedString("PhotoPermissionsRestrictedAlertController.dismissButtonTitle", comment: "Title for the cancel button on the photo permissions restricted alert")

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
