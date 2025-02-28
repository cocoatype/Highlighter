//  Created by Geoff Pado on 8/27/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import DesignSystem
import UIKit

class RedoBarButtonItem: UIBarButtonItem {
    convenience init(undoManager: UndoManager?, target: AnyObject?) {
        self.init(image: Icons.redo, style: .plain, target: target, action: #selector(ActionsBuilderActions.redo(_:)))
        isEnabled = undoManager?.canRedo ?? false
    }
}
