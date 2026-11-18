//  Created by Geoff Pado on 11/14/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import UIKit

import Tools

/// Handles selecting the highlighter tool, from the toolbar, the Mac menu,
/// or the Pencil menu.
final class PhotoEditingToolController: PhotoEditingChainedResponder, HighlighterToolSelectionHandler {
    init(photoEditingView: PhotoEditingScrollView) {
        self.photoEditingView = photoEditingView
        super.init()
    }

    @objc func toggleHighlighterTool() {
        select(photoEditingView.highlighterTool.next)
    }

    @objc func selectHighlighterTool(_ sender: UICommand) {
        guard let index = sender.propertyList as? Int else { return }
        select(HighlighterTool.allCases[index])
    }

    @objc func selectHighlighterTool(_ sender: Any, event: HighlighterToolSelectionEvent) {
        select(event.tool)
    }

    private func select(_ tool: HighlighterTool) {
        photoEditingView.highlighterTool = tool
        sendToEditor(#selector((any PhotoEditingResponderActions).refreshToolbarItems))
    }

    // MARK: Boilerplate

    private let photoEditingView: PhotoEditingScrollView
}
