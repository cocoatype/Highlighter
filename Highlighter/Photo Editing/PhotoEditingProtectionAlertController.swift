//  Created by Geoff Pado on 5/13/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PhotoEditingProtectionAlertController: UIAlertController {
    init(appViewController: AppViewController) {
        self.appViewController = appViewController
        super.init(nibName: nil, bundle: nil)

        title = PhotoEditingProtectionAlertController.alertTitle
        message = PhotoEditingProtectionAlertController.alertMessage

        addAction(closeAction)
        addAction(cancelAction)
    }

    private lazy var closeAction = UIAlertAction(title: PhotoEditingProtectionAlertController.actionButtonTitle, style: .destructive, handler: { [weak self] _ in
        self?.appViewController?.destructivelyDismissPhotoEditingViewController()
    })
    private let cancelAction = UIAlertAction(title: PhotoEditingProtectionAlertController.cancelButtonTitle, style: .cancel, handler: nil)

    // MARK: Boilerplate

    override var preferredStyle: UIAlertController.Style { return .alert }
    weak var appViewController: AppViewController?

    private static let alertTitle = NSLocalizedString("PhotoEditingProtectionAlertController.alertTitle", comment: "Title for the photo permissions denied alert")
    private static let alertMessage = NSLocalizedString("PhotoEditingProtectionAlertController.alertMessage", comment: "Message for the photo permissions denied alert")
    private static let actionButtonTitle = NSLocalizedString("PhotoEditingProtectionAlertController.actionButtonTitle", comment: "Title for the settings button on the photo permissions denied alert")
    private static let cancelButtonTitle = NSLocalizedString("PhotoEditingProtectionAlertController.cancelButtonTitle", comment: "Title for the cancel button on the photo permissions denied alert")

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
