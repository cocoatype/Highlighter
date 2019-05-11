//  Created by Geoff Pado on 5/11/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import SafariServices
import UIKit

class SettingsNavigationController: NavigationController {
    init() {
        super.init(rootViewController: SettingsViewController())
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

    @objc func presentContactViewController() {
        if ContactMailViewController.canBePresented {
            present(ContactMailViewController(), animated: true)
        } else {
            guard let contactViewController = ContactWebViewController() else { return }
            present(contactViewController, animated: true)
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
}
