//  Created by Geoff Pado on 3/31/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class AppViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)

        UIView.appearance().tintColor = .primary

        let navigationController = NavigationController(rootViewController: PhotoSelectionViewController())
        embed(navigationController)
    }

    // MARK: Status Bar

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    override var childForStatusBarStyle: UIViewController? { return nil }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
