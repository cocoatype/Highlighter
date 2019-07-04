//  Created by Geoff Pado on 5/15/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

class ActionNavigationController: NavigationController {
    init() {
        super.init(rootViewController: ActionEditingViewController())
        isToolbarHidden = false
    }

    // MARK: Boilerplate

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
}
