//  Created by Geoff Pado on 8/27/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Foundation

struct ActionSet {
    @ToolbarBuilder var leadingNavigationItems: [UIBarButtonItem] {
        DismissBarButtonItem()

        if #unavailable(iOS 16), sizeClass == .regular {
            UndoBarButtonItem(undoManager: undoManager, target: target)
            RedoBarButtonItem(undoManager: undoManager, target: target)
        }
    }

    @available(iOS 16, *)
    @ToolbarBuilder var centerNavigationItems: [UIBarButtonItem] {
        if sizeClass == .regular {
            UndoBarButtonItem(undoManager: undoManager, target: target)
            RedoBarButtonItem(undoManager: undoManager, target: target)
            ColorPickerBarButtonItem(target: target, color: currentColor)
            SeekBarButtonItem(target: target)
        }
    }

    @ToolbarBuilder var trailingNavigationItems: [UIBarButtonItem] {
        if #unavailable(iOS 16) {
            ShareBarButtonItem(target: target)
        }

        if FeatureFlag.seekAndDestroy, sizeClass == .regular, #unavailable(iOS 16) {
            SeekBarButtonItem(target: target)
        }

        if sizeClass == .regular {
            if #unavailable(iOS 16) {
                ColorPickerBarButtonItem(target: target, color: currentColor)
            }
            HighlighterToolBarButtonItem(tool: selectedTool, target: target)
            if #available(iOS 16, *) {
                ShareBarButtonItem(target: target)
            }
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

            ColorPickerBarButtonItem(target: target, color: currentColor)
            HighlighterToolBarButtonItem(tool: selectedTool, target: target)
        }
    }

    init(for target: AnyObject, undoManager: UndoManager?, selectedTool: HighlighterTool, sizeClass: UIUserInterfaceSizeClass, currentColor: UIColor) {
        self.target = target
        self.undoManager = undoManager
        self.selectedTool = selectedTool
        self.sizeClass = sizeClass
        self.currentColor = currentColor
    }

    private let target: AnyObject
    private let undoManager: UndoManager?
    private let selectedTool: HighlighterTool
    private let sizeClass: UIUserInterfaceSizeClass
    private let currentColor: UIColor
}
