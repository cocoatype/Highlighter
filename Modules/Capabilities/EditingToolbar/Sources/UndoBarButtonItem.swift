//  Created by Geoff Pado on 8/27/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import DesignSystem
import UIKit

class UndoBarButtonItem: UIBarButtonItem {
    convenience init(undoManager: UndoManager?, target: AnyObject?) {
        self.init(image: Icons.undo, style: .plain, target: target, action: #selector(ActionsBuilderActions.undo(_:)))
        isEnabled = undoManager?.canUndo ?? false
    }
}
