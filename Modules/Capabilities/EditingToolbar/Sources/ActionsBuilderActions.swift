//  Created by Geoff Pado on 8/27/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Foundation

@objc protocol ActionsBuilderActions {
    func undo(_ sender: Any)
    func redo(_ sender: Any)
    func toggleHighlighterTool(_ sender: Any)
    func showColorPicker(_ sender: Any)
    func showAutoRedactAccess(_ sender: Any)
    func selectedColorDidChange(_ sender: Any)
    func startSeeking(_ sender: Any)
    func showDebugPreferences(_ sender: Any)
}
