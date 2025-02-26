//  Created by Geoff Pado on 12/5/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Testing
import Tools
import UIKit

@testable import Editing
@testable import Logging

struct PhotoEditingWorkspaceViewTelemetryEventFactoryTests {
    @Test(arguments: [
        (HighlighterTool.magic, UIColor.black, UIColor?.some(.black)),
        (.magic, .red, .red),
        (.lasso, .black, .black),
        (.lasso, .red, .red),
        (.manual, .black, .black),
        (.manual, .red, .red),
        (.eraser, .black, nil),
        (.eraser, .red, nil),
    ])
    func check(tool: HighlighterTool, inputColor: UIColor, outputColor: UIColor?) {
        let event = PhotoEditingWorkspaceViewTelemetryEventFactory().event(
            tool: tool,
            color: inputColor
        )
        #expect(event.name == "PhotoEditingWorkspaceView.strokeCompleted")
        switch tool {
        case .magic:
            #expect(event.info["tool"] == "magic")
        case .lasso:
            #expect(event.info["tool"] == "lasso")
        case .manual:
            #expect(event.info["tool"] == "manual")
        case .eraser:
            #expect(event.info["tool"] == "eraser")
        }

        #expect(event.info["color"] == outputColor?.hexString)
    }
}
