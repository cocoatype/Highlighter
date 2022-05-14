//  Created by Geoff Pado on 8/27/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Foundation

struct ActionSet {
    @ToolbarBuilder var leadingNavigationItems: [UIBarButtonItem] {
        DismissBarButtonItem()

        if sizeClass == .regular {
            UndoBarButtonItem(undoManager: undoManager, target: target)
            RedoBarButtonItem(undoManager: undoManager, target: target)
        }
    }

    @ToolbarBuilder var trailingNavigationItems: [UIBarButtonItem] {
        ShareBarButtonItem(target: target)

        if FeatureFlag.seekAndDestroy, sizeClass == .regular {
            SeekBarButtonItem(target: target)
        }

        if #available(iOS 14, *), sizeClass == .regular {
            ColorPickerBarButtonItem(target: target)
            HighlighterToolBarButtonItem(tool: selectedTool, target: target)
        } else if sizeClass == .regular {
            LegacyHighlighterToolBarButtonItem(tool: selectedTool, target: target)
        }
    }

    @ToolbarBuilder var toolbarItems: [UIBarButtonItem] {
        if sizeClass != .regular {
            UndoBarButtonItem(undoManager: undoManager, target: target)
            RedoBarButtonItem(undoManager: undoManager, target: target)
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

            if FeatureFlag.seekAndDestroy {
                SeekBarButtonItem(target: target)
            }

            if #available(iOS 14, *) {
                ColorPickerBarButtonItem(target: target)
                HighlighterToolBarButtonItem(tool: selectedTool, target: target)
            } else {
                LegacyHighlighterToolBarButtonItem(tool: selectedTool, target: target)
            }
        }
    }

    init(for target: AnyObject, undoManager: UndoManager?, selectedTool: HighlighterTool, sizeClass: UIUserInterfaceSizeClass) {
        self.target = target
        self.undoManager = undoManager
        self.selectedTool = selectedTool
        self.sizeClass = sizeClass
    }

    private let target: AnyObject
    private let undoManager: UndoManager?
    private let selectedTool: HighlighterTool
    private let sizeClass: UIUserInterfaceSizeClass
}
