//  Created by Geoff Pado on 2/25/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import UIKit

#if targetEnvironment(macCatalyst)
class DesktopAppWindow: UIWindow {
    init(windowScene: UIWindowScene, representedURL: URL?) {
        super.init(windowScene: windowScene)

        rootViewController = DesktopViewController(representedURL: representedURL)
        isOpaque = false
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
#endif
