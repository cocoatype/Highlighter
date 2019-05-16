//  Created by Geoff Pado on 3/31/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

class AppViewController: UIViewController, PhotoEditorPresenting {
    init() {
        super.init(nibName: nil, bundle: nil)

        let navigationController = NavigationController(rootViewController: PhotoSelectionViewController())
        embed(navigationController)
    }

    // MARK: Photo Editing View Controller

    func presentPhotoEditingViewController(for asset: PHAsset) {
        present(PhotoEditingNavigationController(asset: asset), animated: true)
    }

    @objc func dismissPhotoEditingViewController() {
        guard let presentedNavigationController = (presentedViewController as? NavigationController),
          let editingViewController = (presentedNavigationController.viewControllers.first as? PhotoEditingViewController)
        else { return }

        guard editingViewController.hasMadeEdits else { dismiss(animated: true); return }

        let alertController = PhotoEditingProtectionAlertController(appViewController: self)
        editingViewController.present(alertController, animated: true)
    }

    @objc func destructivelyDismissPhotoEditingViewController() {
        if let presentedNavigationController = (presentedViewController as? NavigationController),
          let rootViewController = presentedNavigationController.viewControllers.first,
          rootViewController is PhotoEditingViewController {
            dismiss(animated: true)
        }
    }

    // MARK: Settings View Controller

    @objc func presentSettingsViewController() {
        present(SettingsNavigationController(), animated: true)
    }

    @objc func dismissSettingsViewController() {
        if presentedViewController is SettingsNavigationController {
            dismiss(animated: true)
        }
    }

    // MARK: Status Bar

    override var childForStatusBarStyle: UIViewController? { return children.first }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
