//  Created by Geoff Pado on 2/22/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Testing

@testable import Tools

struct HighlighterToolTests {
    @Test(arguments: [
        (HighlighterTool.magic, ToolsAsset.highlighterMagic),
        (.manual, ToolsAsset.highlighterManual),
        (.eraser, ToolsAsset.highlighterEraser),
    ])
    func toolsImage(tool: HighlighterTool, image: ToolsImages) {
        #expect(tool.toolsImage.name == image.name)
    }

    @Test(arguments: [
        (HighlighterTool.magic, ToolsAsset.highlighterMagic),
        (.manual, ToolsAsset.highlighterManual),
        (.eraser, ToolsAsset.highlighterEraser),
    ])
    func image(tool: HighlighterTool, image: ToolsImages) {
        #expect(tool.toolsImage.image == image.image)
    }

    @Test(arguments: [
        (HighlighterTool.magic, HighlighterTool.manual),
        (.manual, .eraser),
        (.eraser, .magic),
    ])
    func next(current: HighlighterTool, expected: HighlighterTool) {
        #expect(current.next == expected)
    }
}
