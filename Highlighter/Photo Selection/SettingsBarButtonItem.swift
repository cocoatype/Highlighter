//  Created by Geoff Pado on 5/16/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Editing
import UIKit

class SettingsBarButtonItem: UIBarButtonItem {
    static var standard: SettingsBarButtonItem {
        let standard = SettingsBarButtonItem(image: Icons.help, style: .plain, target: nil, action: #selector(AppViewController.presentSettingsViewController))
        standard.accessibilityLabel = Self.settingsButtonAccessibilityLabel
        return standard
    }

    private static let settingsButtonAccessibilityLabel = NSLocalizedString("PhotoSelectionViewController.settingsButtonAccessibilityLabel", comment: "Accessibility label for the button to get to settings")

    // MARK: Boilerplate

    override init() { super.init() }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
}
