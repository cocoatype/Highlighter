//  Created by Geoff Pado on 5/16/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import DesignSystem
import UIKit

public class SettingsBarButtonItem: UIBarButtonItem {
    public static var standard: SettingsBarButtonItem {
        let standard = SettingsBarButtonItem(image: Icons.help, style: .plain, target: nil, action: #selector(Actions.presentSettingsViewController))
        standard.accessibilityLabel = MobileSettingsUIStrings.SettingsBarButtonItem.accessibilityLabel
        return standard
    }

    @objc public protocol Actions {
        @MainActor func presentSettingsViewController()
    }

    // MARK: Boilerplate

    override init() { super.init() }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
}
