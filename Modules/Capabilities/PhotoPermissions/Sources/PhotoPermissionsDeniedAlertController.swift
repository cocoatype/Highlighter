//  Created by Geoff Pado on 4/13/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import DesignSystem
import UIKit

@MainActor
public struct PhotoPermissionsDeniedAlertFactory {
    public init() {
        self.init(urlOpener: UIApplication.shared)
    }

    private let urlOpener: any URLOpening
    init(urlOpener: any URLOpening) {
        self.urlOpener = urlOpener
    }

    public func alert() -> UIAlertController {
        let alertController = UIAlertController(title: Strings.alertTitle, message: Strings.alertMessage, preferredStyle: .alert)
        alertController.view.tintColor = .controlTint

        alertController.addAction(settingsAction())
        alertController.addAction(cancelAction)

        return alertController
    }

    private func settingsAction() -> PhotoPermissionsAlertAction {
        PhotoPermissionsAlertAction.action(title: Strings.actionButtonTitle, style: .default) {
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            urlOpener.open(settingsURL, options: [:], completionHandler: nil)
        }
    }
    private let cancelAction = PhotoPermissionsAlertAction.action(title: Strings.cancelButtonTitle, style: .cancel, handlerBody: nil)

    typealias Strings = PhotoPermissionsStrings.PhotoPermissionsDeniedAlertFactory
}

protocol URLOpening {
    @MainActor func open(
        _ url: URL,
        options: [UIApplication.OpenExternalURLOptionsKey : Any],
        completionHandler completion: (@MainActor @Sendable (Bool) -> Void)?
    )
}
extension UIApplication: URLOpening {}
