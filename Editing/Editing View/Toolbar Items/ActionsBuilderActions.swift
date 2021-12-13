//  Created by Geoff Pado on 8/27/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

@objc protocol ActionsBuilderActions {
    func undo(_ sender: Any)
    func redo(_ sender: Any)
    func toggleHighlighterTool(_ sender: Any)
    func showColorPicker(_ sender: Any)
    func startSeeking(_ sender: Any)
}
