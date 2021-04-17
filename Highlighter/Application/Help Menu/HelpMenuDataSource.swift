//  Created by Geoff Pado on 2/25/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Foundation

#if targetEnvironment(macCatalyst)
class HelpMenuDataSource: NSObject {
    var helpMenu: UIMenu {
        UIMenu(options: .displayInline, children: menuItems)
    }

    private let menuItems = [
        HelpMenuAboutAction(),
        HelpMenuPrivacyAction(),
        HelpMenuAcknowledgementsAction(),
        HelpMenuContactAction()
    ]
}
#endif
