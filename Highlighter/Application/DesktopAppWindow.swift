//  Created by Geoff Pado on 2/25/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Editing
import UIKit

#if targetEnvironment(macCatalyst)
class DesktopAppWindow: UIWindow {
    init(windowScene: UIWindowScene, representedURL: URL?, redactions: [Redaction]?) {
        desktopViewController = DesktopViewController(representedURL: representedURL, redactions: redactions)
        super.init(windowScene: windowScene)

        rootViewController = desktopViewController
        isOpaque = false
    }

    var stateRestorationActivity: NSUserActivity? {
        desktopViewController.stateRestorationActivity
    }

    // MARK: Boilerplate

    let desktopViewController: DesktopViewController

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
#endif
