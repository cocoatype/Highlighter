//  Created by Geoff Pado on 5/11/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import DesignSystem
import UIKit

public class AutoRedactionsAccessNavigationController: UINavigationController {
    public init() {
        super.init(navigationBarClass: NavigationBar.self, toolbarClass: UIToolbar.self)
        setViewControllers([AutoRedactionsAccessViewController()], animated: false)

        if #available(iOS 15.0, *) {
            sheetPresentationController?.detents = [.medium()]
        }
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
