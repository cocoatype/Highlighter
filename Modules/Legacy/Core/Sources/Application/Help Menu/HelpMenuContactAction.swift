//  Created by Geoff Pado on 4/17/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import MobileSettingsUI
import UIKit

#if targetEnvironment(macCatalyst)
class HelpMenuContactAction: UIAction {
    convenience init(void: Void = ()) {
        self.init(title: Self.menuItemTitle) { _ in
            UIApplication.shared.open(URL(websitePath: "contact"), options: [:], completionHandler: nil)
        }
    }

    // MARK: Boilerplate

    private static let menuItemTitle = MobileSettingsUI.Strings.SettingsContentContactSection.header

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("\(String(describing: type(of: Self.self))) does not implement init(coder:)")
    }
}
#endif
