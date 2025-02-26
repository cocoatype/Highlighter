//  Created by Geoff Pado on 2/25/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Tools
import Testing

@testable import EditingToolbar

@MainActor
struct HighlighterToolBarButtonItemTests {
    private typealias Strings = EditingToolbarStrings.HighlighterToolBarButtonItem

    @Test(arguments: [
        HighlighterTool.magic,
        .lasso,
        .manual,
        .eraser,
    ])
    func title(tool: HighlighterTool) {
        let item = HighlighterToolBarButtonItem(tool: tool, target: nil)
        #expect(item.title == Strings.buttonTitle)
    }

    @Test(arguments: [
        (HighlighterTool.magic, Strings.magicToolItem),
        (.lasso, Strings.lassoToolItem),
        (.manual, Strings.manualToolItem),
        (.eraser, Strings.eraserToolItem),
    ])
    func accessibilityValue(tool: HighlighterTool, expectedValue: String) {
        let item = HighlighterToolBarButtonItem(tool: tool, target: nil)
        #expect(item.accessibilityValue == expectedValue)
    }
}
