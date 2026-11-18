//  Created by Geoff Pado on 11/14/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import UIKit

/// Owns the editor's undo manager and handles undo and redo actions.
final class PhotoEditingHistoryController: PhotoEditingChainedResponder {
    private let localUndoManager = UndoManager()
    override var undoManager: UndoManager? { localUndoManager }

    @objc func undo(_ sender: Any) {
        localUndoManager.undo()
        sendToEditor(#selector((any PhotoEditingResponderActions).refreshToolbarItems))
    }

    @objc func redo(_ sender: Any) {
        localUndoManager.redo()
        sendToEditor(#selector((any PhotoEditingResponderActions).refreshToolbarItems))
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        switch action {
        case #selector(undo(_:)): localUndoManager.canUndo
        case #selector(redo(_:)): localUndoManager.canRedo
        default: super.canPerformAction(action, withSender: sender)
        }
    }
}
