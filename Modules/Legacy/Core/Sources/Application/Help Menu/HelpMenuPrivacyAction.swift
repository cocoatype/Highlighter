//  Created by Geoff Pado on 4/17/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import MobileSettingsUI
import UIKit

#if targetEnvironment(macCatalyst)
class HelpMenuPrivacyAction: UIAction {
    convenience init(void: Void = ()) {
        self.init(title: Self.menuItemTitle) { _ in
            UIApplication.shared.open(URL(websitePath: "privacy"), options: [:], completionHandler: nil)
        }
    }

    // MARK: Boilerplate

    private static let menuItemTitle = MobileSettingsUI.Strings.SettingsContentInformationSection.privacyTitle

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("\(String(describing: type(of: Self.self))) does not implement init(coder:)")
    }
}
#endif
