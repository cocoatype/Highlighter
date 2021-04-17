//  Created by Geoff Pado on 4/17/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import UIKit

#if targetEnvironment(macCatalyst)
class HelpMenuPrivacyAction: UIAction {
    convenience init(void: Void = ()) {
        self.init(title: Self.menuItemTitle) { _ in
            UIApplication.shared.open(PrivacyViewController.url, options: [:], completionHandler: nil)
        }
    }

    // MARK: Boilerplate

    private static let menuItemTitle = NSLocalizedString("SettingsContentProvider.Item.privacy", comment: "Privacy menu item title")

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("\(String(describing: type(of: Self.self))) does not implement init(coder:)")
    }
}
#endif
