//  Created by Geoff Pado on 4/3/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

open class NavigationController: UINavigationController {
    public override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: NavigationBar.self, toolbarClass: Toolbar.self)
        setViewControllers([rootViewController], animated: false)
    }

    // MARK: Status Bar

    open override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    open override var childForStatusBarStyle: UIViewController? { return nil }

    // MARK: Boilerplate

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    public required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
