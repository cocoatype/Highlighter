//  Created by Geoff Pado on 4/3/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class NavigationController: UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: NavigationBar.self, toolbarClass: Toolbar.self)
        setViewControllers([rootViewController], animated: false)

        let appearance = UIBarButtonItem.appearance()
        appearance.setTitleTextAttributes([
            .font: UIFont.navigationBarButtonFont
        ], for: .normal)
        appearance.setTitleTextAttributes([
            .font: UIFont.navigationBarButtonFont
        ], for: .highlighted)
    }

    // MARK: Status Bar

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    override var childForStatusBarStyle: UIViewController? { return nil }

    // MARK: Boilerplate

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
