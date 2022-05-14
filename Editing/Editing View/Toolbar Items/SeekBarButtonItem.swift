//  Created by Geoff Pado on 12/6/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import UIKit

class SeekBarButtonItem: UIBarButtonItem {
    convenience init(target: AnyObject?) {
        self.init(image: Icons.seekAndDestroy, style: .plain, target: target, action: #selector(ActionsBuilderActions.startSeeking(_:)))
    }
}
