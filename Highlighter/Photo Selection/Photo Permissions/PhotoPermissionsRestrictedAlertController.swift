//  Created by Geoff Pado on 5/13/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

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
