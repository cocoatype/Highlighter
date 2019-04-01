//  Created by Geoff Pado on 3/31/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class AppWindow: UIWindow {
    init() {
        super.init(frame: UIScreen.main.bounds)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
