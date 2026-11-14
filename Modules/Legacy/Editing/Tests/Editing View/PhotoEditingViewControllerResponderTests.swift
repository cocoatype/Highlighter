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
        "refreshToolbarItems": PhotoEditingToolbarController.self,
        "selectHighlighterTool:": PhotoEditingToolController.self,
        "toggleColorPicker:": PhotoEditingColorPickerController.self,
        "showColorPicker:": PhotoEditingColorPickerController.self,
        "toggleSeeking:": PhotoEditingSeekController.self,
        "startSeeking:": PhotoEditingSeekController.self,
        "cancelSeeking:": PhotoEditingSeekController.self,
        "finishSeeking:": PhotoEditingSeekController.self,
        "seekBarDidChangeText:": PhotoEditingSeekController.self,
        "sharePhoto:": PhotoEditingShareController.self,

        // EditingToolbar's ActionsBuilderActions & ToolbarActions
        "toggleHighlighterTool": PhotoEditingToolController.self,
        "selectedColorDidChange:": PhotoEditingColorPickerController.self,
        "showAutoRedactAccess:": PhotoEditingAutoRedactAccessController.self,
        "hideAutoRedactAccess:": PhotoEditingAutoRedactAccessController.self,
        "showDebugPreferences:": PhotoEditingViewController.self,
        "selectHighlighterTool:event:": PhotoEditingToolController.self,

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

    @Test func navigationControllerForwardsUnhandledActionsToEditingChain() {
        let navigationController = PhotoEditingNavigationController(image: UIImage())
        let presentedResponder = PresentedResponder(next: navigationController)

        let finishSeeking = NSSelectorFromString("finishSeeking:")
        #expect(presentedResponder.target(forAction: finishSeeking, withSender: nil) is PhotoEditingSeekController)

        let unhandled = NSSelectorFromString("notARealAction:")
        #expect(presentedResponder.target(forAction: unhandled, withSender: nil) == nil)
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
        #expect(viewController.target(forAction: undo, withSender: nil) is PhotoEditingHistoryController)
        #expect(viewController.target(forAction: redo, withSender: nil) == nil)

        undoManager.undo()
        #expect(viewController.target(forAction: redo, withSender: nil) is PhotoEditingHistoryController)
    }
}

/// Stands in for a view controller presented from the navigation
/// controller, whose responder chain skips the editing view controller.
private class PresentedResponder: UIResponder {
    init(next: UIResponder) {
        self.followingResponder = next
    }

    private let followingResponder: UIResponder
    override var next: UIResponder? { followingResponder }
}
