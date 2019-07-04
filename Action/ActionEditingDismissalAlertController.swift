//  Created by Geoff Pado on 7/3/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class ActionEditingDismissalAlertController: UIAlertController {
    init(completionHandler: @escaping ((Response) -> Void)) {
        self.completionHandler = completionHandler
        super.init(nibName: nil, bundle: nil)

        addAction(saveAction)
        addAction(deleteAction)
        addAction(cancelAction)
    }

    var barButtonItem: UIBarButtonItem? {
        get { return popoverPresentationController?.barButtonItem }
        set(newButtonItem) {
            popoverPresentationController?.barButtonItem = newButtonItem
        }
    }

    private lazy var saveAction = UIAlertAction(title: ActionEditingDismissalAlertController.saveButtonTitle, style: .default, handler: { [weak self] _ in
        self?.completionHandler(.save)
    })
    private lazy var deleteAction = UIAlertAction(title: ActionEditingDismissalAlertController.deleteButtonTitle, style: .destructive, handler: { [weak self] _ in
        self?.completionHandler(.delete)
    })
    private let cancelAction = UIAlertAction(title: ActionEditingDismissalAlertController.cancelButtonTitle, style: .cancel, handler: nil)

    enum Response {
        case save, delete
    }

    // MARK: Boilerplate

    override var preferredStyle: UIAlertController.Style { return .actionSheet }

    private static let cancelButtonTitle = NSLocalizedString("ActionEditingDismissalAlertController.cancelButtonTitle", comment: "Title for the cancel button on the photo permissions denied alert")
    private static let deleteButtonTitle = NSLocalizedString("ActionEditingDismissalAlertController.deleteButtonTitle", comment: "Title for the delete button on the photo permissions denied alert")
    private static let saveButtonTitle = NSLocalizedString("ActionEditingDismissalAlertController.saveButtonTitle", comment: "Title for the save button on the photo permissions denied alert")

    private let completionHandler: ((Response) -> Void)

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
