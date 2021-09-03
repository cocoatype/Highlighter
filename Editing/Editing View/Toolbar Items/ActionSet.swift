//  Created by Geoff Pado on 8/27/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Foundation

struct ActionSet {
    let leadingNavigationItems: [UIBarButtonItem]
    let trailingNavigationItems: [UIBarButtonItem]
    let toolbarItems: [UIBarButtonItem]

    static func spacer() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }

    static func actionSet(for target: AnyObject, undoManager: UndoManager?, selectedTool: HighlighterTool, sizeClass: UIUserInterfaceSizeClass) -> ActionSet {
        switch sizeClass {
        case .regular:
            if #available(iOS 14, *) {
                return regularActionSet(for: target, undoManager: undoManager, selectedTool: selectedTool)
            } else {
                return legacyRegularActionSet(for: target, undoManager: undoManager, selectedTool: selectedTool)
            }
        case .unspecified, .compact: fallthrough
        @unknown default:
            if #available(iOS 14, *) {
                return compactActionSet(for: target, undoManager: undoManager, selectedTool: selectedTool)
            } else {
                return legacyCompactActionSet(for: target, undoManager: undoManager, selectedTool: selectedTool)
            }
        }
    }

    @available(iOS 14, *)
    private static func regularActionSet(for target: AnyObject, undoManager: UndoManager?, selectedTool: HighlighterTool) -> ActionSet {
        ActionSet(
            leadingNavigationItems: [
                DismissBarButtonItem(),
                UndoBarButtonItem(undoManager: undoManager, target: target),
                RedoBarButtonItem(undoManager: undoManager, target: target)
            ],
            trailingNavigationItems: [
                ShareBarButtonItem(target: target),
                ColorPickerBarButtonItem(target: target),
                HighlighterToolBarButtonItem(tool: selectedTool, target: target)
            ],
            toolbarItems: [])
    }

    private static func legacyRegularActionSet(for target: AnyObject, undoManager: UndoManager?, selectedTool: HighlighterTool) -> ActionSet {
        ActionSet(
            leadingNavigationItems: [
                DismissBarButtonItem(),
                UndoBarButtonItem(undoManager: undoManager, target: target),
                RedoBarButtonItem(undoManager: undoManager, target: target)
            ],
            trailingNavigationItems: [
                ShareBarButtonItem(target: target),
                LegacyHighlighterToolBarButtonItem(tool: selectedTool, target: target)
            ],
            toolbarItems: [])
    }

    @available(iOS 14, *)
    private static func compactActionSet(for target: AnyObject, undoManager: UndoManager?, selectedTool: HighlighterTool) -> ActionSet {
        ActionSet(
            leadingNavigationItems: [
                DismissBarButtonItem()
            ],
            trailingNavigationItems: [
                ShareBarButtonItem(target: target)
            ],
            toolbarItems: [
                UndoBarButtonItem(undoManager: undoManager, target: target),
                RedoBarButtonItem(undoManager: undoManager, target: target),
                spacer(),
                ColorPickerBarButtonItem(target: target),
                HighlighterToolBarButtonItem(tool: selectedTool, target: target)
            ])
    }

    private static func legacyCompactActionSet(for target: AnyObject, undoManager: UndoManager?, selectedTool: HighlighterTool) -> ActionSet {
        ActionSet(
            leadingNavigationItems: [
            ],
            trailingNavigationItems: [
            ],
            toolbarItems: [
                UndoBarButtonItem(undoManager: undoManager, target: target),
                RedoBarButtonItem(undoManager: undoManager, target: target),
                spacer(),
                LegacyHighlighterToolBarButtonItem(tool: selectedTool, target: target)
            ])
    }
}
