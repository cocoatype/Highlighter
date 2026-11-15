//  Created by Geoff Pado on 11/9/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import DesignSystem
import UIKit

/// The settings screen as presented from the app: a navigation controller showing the settings list.
public class SettingsHostingController: UINavigationController {
    public init() {
        super.init(navigationBarClass: NavigationBar.self, toolbarClass: nil)
        // a navigation controller takes its preferred content size from its top view controller
        let settingsViewController = SettingsViewController()
        settingsViewController.preferredContentSize = CGSize(width: 640, height: 640)
        setViewControllers([settingsViewController], animated: false)

        modalPresentationStyle = .formSheet
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
