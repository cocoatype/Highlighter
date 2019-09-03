//  Created by Geoff Pado on 8/3/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class AutoRedactionsAdditionDialogFactory: NSObject {
    static func newDialog(completionHandler: @escaping ((String?) -> Void)) -> UIAlertController {
        let alertController = UIAlertController(title: AutoRedactionsAdditionDialogFactory.dialogTitle, message: nil, preferredStyle: .alert)
        alertController.view.tintColor = .controlTint

        let addWordAction = UIAlertAction(title: AutoRedactionsAdditionDialogFactory.addButtonTitle, style: .default) { [weak alertController] _ in
            completionHandler(alertController?.textFields?.first?.text)
        }

        alertController.addAction(addWordAction)
        alertController.addTextField { textField in
            textField.autocapitalizationType = .none
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.placeholder = AutoRedactionsAdditionDialogFactory.placeholder
        }

        return alertController
    }

    // MARK: Localized Strings

    private static let addButtonTitle = NSLocalizedString("AutoRedactionsAdditionDialogFactory.addButtonTitle", comment: "Title for the add button on the auto redactions addition dialog")
    private static let placeholder = NSLocalizedString("AutoRedactionsAdditionDialogFactory.placeholder", comment: "Placeholder for the auto redactions addition dialog")
    private static let dialogTitle = NSLocalizedString("AutoRedactionsAdditionDialogFactory.dialogTitle", comment: "Title for the auto redactions addition dialog")
}
