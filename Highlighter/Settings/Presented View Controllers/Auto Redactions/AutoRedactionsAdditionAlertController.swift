//  Created by Geoff Pado on 8/3/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class AutoRedactionsAdditionAlertController: UIAlertController {
    init(completionHandler: @escaping ((String?) -> Void)) {
        self.completionHandler = completionHandler
        super.init(nibName: nil, bundle: nil)

        addAction(addWordAction)
        addTextField { textField in
            textField.autocapitalizationType = .none
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.placeholder = AutoRedactionsAdditionAlertController.placeholder
        }

        title = AutoRedactionsAdditionAlertController.dialogTitle
    }

    private lazy var addWordAction = UIAlertAction(title: AutoRedactionsAdditionAlertController.addButtonTitle, style: .default) { [weak self] _ in
        self?.completionHandler(self?.textFields?.first?.text)
    }

    // MARK: Boilerplate

    override var preferredStyle: UIAlertController.Style { return .alert }

    private static let addButtonTitle = NSLocalizedString("AutoRedactionsAdditionAlertController.addButtonTitle", comment: "Title for the add button on the auto redactions addition dialog")
    private static let placeholder = NSLocalizedString("AutoRedactionsAdditionAlertController.placeholder", comment: "Placeholder for the auto redactions addition dialog")
    private static let dialogTitle = NSLocalizedString("AutoRedactionsAdditionAlertController.dialogTitle", comment: "Title for the auto redactions addition dialog")

    private let completionHandler: (String?) -> Void

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
