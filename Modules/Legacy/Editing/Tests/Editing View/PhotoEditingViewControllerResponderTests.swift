//  Created by Geoff Pado on 11/14/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import Testing
import UIKit

import FactoryKit

import PurchasingDoubles

@testable import Editing

@MainActor @Suite(.container)
struct PhotoEditingViewControllerResponderTests {
    init() {
        Container.shared.purchaseRepository.register {
            SpyRepository(withCheese: .purchased)
        }
    }

    /// The responder expected to handle each action sent to the editor,
    /// whether by a bar button item, a key command, or up the responder chain.
    private static let expectedHandlers: [String: AnyClass] = [
        // PhotoEditingResponderActions
        "refreshToolbarItems": PhotoEditingViewController.self,
        "selectHighlighterTool:": PhotoEditingViewController.self,
        "toggleColorPicker:": PhotoEditingViewController.self,
        "showColorPicker:": PhotoEditingViewController.self,
        "toggleSeeking:": PhotoEditingViewController.self,
        "startSeeking:": PhotoEditingViewController.self,
        "cancelSeeking:": PhotoEditingViewController.self,
        "finishSeeking:": PhotoEditingViewController.self,
        "seekBarDidChangeText:": PhotoEditingViewController.self,
        "sharePhoto:": PhotoEditingViewController.self,

        // EditingToolbar's ActionsBuilderActions & ToolbarActions
        "toggleHighlighterTool": PhotoEditingViewController.self,
        "selectedColorDidChange:": PhotoEditingViewController.self,
        "showAutoRedactAccess:": PhotoEditingViewController.self,
        "showDebugPreferences:": PhotoEditingViewController.self,
        "selectHighlighterTool:event:": PhotoEditingViewController.self,

        // Workspace actions
        "markHasMadeEdits": PhotoEditingViewController.self,
        "updatePencilMenu:event:": PhotoEditingViewController.self,
    ]

    @Test func actionsAreHandledByExpectedResponders() {
        let viewController = PhotoEditingViewController()

        for (selectorName, expectedHandler) in Self.expectedHandlers {
            let handler = viewController.target(forAction: NSSelectorFromString(selectorName), withSender: nil) as AnyObject?
            let handlerType = handler.map { ObjectIdentifier(type(of: $0)) }
            #expect(handlerType == ObjectIdentifier(expectedHandler), "\(selectorName) handled by \(String(describing: handler))")
        }
    }

    @Test func undoIsOnlyAvailableWhenUndoManagerCanUndo() throws {
        let viewController = PhotoEditingViewController()
        let undoManager = try #require(viewController.undoManager)
        let undo = NSSelectorFromString("undo:")
        let redo = NSSelectorFromString("redo:")

        #expect(viewController.target(forAction: undo, withSender: nil) == nil)
        #expect(viewController.target(forAction: redo, withSender: nil) == nil)

        func registerUndo() {
            undoManager.registerUndo(withTarget: viewController) { _ in registerUndo() }
        }
        registerUndo()
        #expect(viewController.target(forAction: undo, withSender: nil) != nil)
        #expect(viewController.target(forAction: redo, withSender: nil) == nil)

        undoManager.undo()
        #expect(viewController.target(forAction: redo, withSender: nil) != nil)
    }
}
