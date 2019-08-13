//  Created by Geoff Pado on 5/11/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import UIKit

class SettingsNavigationController: NavigationController {
    init() {
        super.init(rootViewController: SettingsViewController())
        modalPresentationStyle = .formSheet
    }

    // MARK: Navigation

    @objc func presentAboutViewController() {
        guard let aboutViewController = AboutViewController() else { return }
        present(aboutViewController, animated: true)
    }

    @objc func presentAcknowledgementsViewController() {
        guard let acknowledgementsViewController = AcknowledgementsViewController() else { return }
        present(acknowledgementsViewController, animated: true)
    }

    @objc func presentAutoRedactionsEditViewController() {
        pushViewController(AutoRedactionsEditViewController(), animated: true)
    }

    @objc func presentContactViewController() {
        if ContactMailViewController.canBePresented {
            let contactViewController = ContactMailViewController()
            present(contactViewController, animated: true)
        } else {
            guard let contactViewController = ContactWebViewController() else { return }
            present(contactViewController, animated: true)
        }
    }

    @objc func dismissContactMailViewController() {
        if presentedViewController is ContactMailViewController {
            dismiss(animated: true)
        }
    }

    @objc func presentPrivacyViewController() {
        guard let privacyViewController = PrivacyViewController() else { return }
        present(privacyViewController, animated: true)
    }

    // MARK: Boilerplate

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
