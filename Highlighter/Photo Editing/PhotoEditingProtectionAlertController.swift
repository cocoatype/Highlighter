//  Created by Geoff Pado on 5/13/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PhotoEditingProtectionAlertController: UIAlertController {
    init(appViewController: AppViewController) {
        self.appViewController = appViewController
        super.init(nibName: nil, bundle: nil)
        view.tintColor = .controlTint

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

    private lazy var saveAction = UIAlertAction(title: PhotoEditingProtectionAlertController.saveButtonTitle, style: .default, handler: { [weak self] _ in
        self?.appViewController?.dismissPhotoEditingViewControllerAfterSaving()
    })
    private lazy var deleteAction = UIAlertAction(title: PhotoEditingProtectionAlertController.deleteButtonTitle, style: .destructive, handler: { [weak self] _ in
        self?.appViewController?.destructivelyDismissPhotoEditingViewController()
    })
    private let cancelAction = UIAlertAction(title: PhotoEditingProtectionAlertController.cancelButtonTitle, style: .cancel, handler: nil)

    // MARK: Boilerplate

    override var preferredStyle: UIAlertController.Style {
        #if targetEnvironment(macCatalyst)
        return .alert
        #else
        return .actionSheet
        #endif
    }
    weak var appViewController: AppViewController?

    private static let cancelButtonTitle = NSLocalizedString("PhotoEditingProtectionAlertController.cancelButtonTitle", comment: "Title for the cancel button on the photo permissions denied alert")
    private static let deleteButtonTitle = NSLocalizedString("PhotoEditingProtectionAlertController.deleteButtonTitle", comment: "Title for the delete button on the photo permissions denied alert")
    private static let saveButtonTitle = NSLocalizedString("PhotoEditingProtectionAlertController.saveButtonTitle", comment: "Title for the save button on the photo permissions denied alert")

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
