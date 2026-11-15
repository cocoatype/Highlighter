//  Created by Geoff Pado on 8/1/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import UIKit

public class HighlighterToolSelectionEvent: UIEvent {
    public let tool: HighlighterTool
    public init(tool: HighlighterTool) {
        self.tool = tool
        super.init()
    }
}

@MainActor
@objc public protocol HighlighterToolSelectionHandler {
    @objc func selectHighlighterTool(_ sender: Any, event: HighlighterToolSelectionEvent)
}
