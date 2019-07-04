//  Created by Geoff Pado on 7/1/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class ActionViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)

        let navigationController = ActionNavigationController()
        embed(navigationController)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
