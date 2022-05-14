//  Created by Geoff Pado on 8/27/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import UIKit

class ShareBarButtonItem: UIBarButtonItem {
    convenience init(target: AnyObject?) {
        self.init(barButtonSystemItem: .action, target: target, action: #selector(PhotoEditingViewController.sharePhoto))
    }
}
