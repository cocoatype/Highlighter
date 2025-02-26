//  Created by Geoff Pado on 2/25/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Tools
import UIKit

@objc protocol ToolbarActions {
    func dismissPhotoEditingViewController(
        _ sender: UIBarButtonItem,
        event: DismissBarButtonItem.Event
    )
    func selectHighlighterTool(_ sender: Any, event: HighlighterToolSelectionEvent)
    func sharePhoto(_ sender: Any)
}
