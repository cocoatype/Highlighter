//  Created by Geoff Pado on 8/27/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

import FactoryKit

import BarBuilder
import Defaults
import FeatureFlagging
import Purchasing
import Tools

@MainActor
public struct ActionSet {
    @BarBuilder public var leadingNavigationItems: [UIBarButtonItem] {
        DismissBarButtonItem(asset: asset)

        if #unavailable(iOS 16), sizeClass == .regular {
            UndoBarButtonItem(undoManager: undoManager, target: target(for: #selector((any ActionsBuilderActions).undo(_:))))
            RedoBarButtonItem(undoManager: undoManager, target: target(for: #selector((any ActionsBuilderActions).redo(_:))))
        }
    }

    @available(iOS 16, *)
    @BarBuilder public var centerNavigationItems: [UIBarButtonItem] {
        if sizeClass == .regular {
            UndoBarButtonItem(undoManager: undoManager, target: target(for: #selector((any ActionsBuilderActions).undo(_:))))
            RedoBarButtonItem(undoManager: undoManager, target: target(for: #selector((any ActionsBuilderActions).redo(_:))))
            UIBarButtonItem.fixedSpace(0)
            ColorPickerBarButtonItem(target: target(for: #selector((any ActionsBuilderActions).selectedColorDidChange(_:))), color: currentColor)
            UIBarButtonItem.fixedSpace(0)
            SeekBarButtonItem(target: target(for: #selector((any ActionsBuilderActions).startSeeking(_:))))

            if shouldShowQuickRedact { QuickRedactBarButtonItem(target: target(for: #selector((any ActionsBuilderActions).showAutoRedactAccess(_:)))) }
        }
    }

    // 🧑‍💻👋👋👋🧑‍💻🏠🕖🤣💜😍💜😍🕙😒😒😒🕙👋😍🤣 by @Eskeminha on 2024-05-03
    // the standard set of trailing navigation items
    @BarBuilder private var 🧑‍💻👋👋👋🧑‍💻🏠🕖🤣💜😍💜😍🕙😒😒😒🕙👋😍🤣: [UIBarButtonItem] {
        if featureFlagProvider.shouldShowDebugOverlay { DebugPreferencesBarButtonItem(target: target(for: #selector((any ActionsBuilderActions).showDebugPreferences(_:)))) }

        ShareBarButtonItem(target: target(for: #selector((any ToolbarActions).sharePhoto(_:))))

        SeekBarButtonItem(target: target(for: #selector((any ActionsBuilderActions).startSeeking(_:))))

        if shouldShowQuickRedact { QuickRedactBarButtonItem(target: target(for: #selector((any ActionsBuilderActions).showAutoRedactAccess(_:)))) }
    }

    @BarBuilder public var trailingNavigationItems: [UIBarButtonItem] {
        if #unavailable(iOS 16) {
            🧑‍💻👋👋👋🧑‍💻🏠🕖🤣💜😍💜😍🕙😒😒😒🕙👋😍🤣
        }

        if sizeClass == .regular, #unavailable(iOS 16) {
            SeekBarButtonItem(target: target(for: #selector((any ActionsBuilderActions).startSeeking(_:))))
            if shouldShowQuickRedact { QuickRedactBarButtonItem(target: target(for: #selector((any ActionsBuilderActions).showAutoRedactAccess(_:)))) }
        }

        if sizeClass == .regular {
            if #unavailable(iOS 16) {
                ColorPickerBarButtonItem(target: target(for: #selector((any ActionsBuilderActions).selectedColorDidChange(_:))), color: currentColor)
            }
            HighlighterToolBarButtonItem(tool: selectedTool, target: target)
            if #available(iOS 16, *) {
                ShareBarButtonItem(target: target(for: #selector((any ToolbarActions).sharePhoto(_:))))
            }
        } else if #available(iOS 16, *) {
            🧑‍💻👋👋👋🧑‍💻🏠🕖🤣💜😍💜😍🕙😒😒😒🕙👋😍🤣
        }
    }

    @BarBuilder public var toolbarItems: [UIBarButtonItem] {
        if sizeClass != .regular {
            UndoBarButtonItem(undoManager: undoManager, target: target(for: #selector((any ActionsBuilderActions).undo(_:))))
            if #unavailable(iOS 26.0) {
                UIBarButtonItem.flexibleSpace()
            }
            RedoBarButtonItem(undoManager: undoManager, target: target(for: #selector((any ActionsBuilderActions).redo(_:))))
            UIBarButtonItem.flexibleSpace()
            ColorPickerBarButtonItem(target: target(for: #selector((any ActionsBuilderActions).selectedColorDidChange(_:))), color: currentColor)
            if #unavailable(iOS 26.0) {
                UIBarButtonItem.flexibleSpace()
            }
            HighlighterToolBarButtonItem(tool: selectedTool, target: target)
        }
    }

    // MARK: Decisions

    private var shouldShowQuickRedact: Bool {
        let isPurchased = allTextIsSpecial.withCheese == .purchased
        let hideAutoRedactions = defaults.value(for: Keys.hideAutoRedactions)
        return isPurchased || hideAutoRedactions == false
    }

    // MARK: Targets

    /// Finds the responder that will handle `action`, starting from `target`
    /// and walking up its responder chain. Falls back to `target` itself if it
    /// responds to `action`, or to `nil` (sending the action up the first
    /// responder's chain) otherwise.
    private func target(for action: Selector) -> AnyObject? {
        if let responder = target as? UIResponder,
           let resolved = responder.target(forAction: action, withSender: nil) as AnyObject? {
            return resolved
        }

        return target.responds(to: action) ? target : nil
    }

    // MARK: Boilerplate

    public init(
        for target: AnyObject,
        undoManager: UndoManager?,
        selectedTool: HighlighterTool,
        sizeClass: UIUserInterfaceSizeClass,
        currentColor: UIColor,
        asset: PHAsset?,
    ) {
        self.target = target
        self.undoManager = undoManager
        self.selectedTool = selectedTool
        self.sizeClass = sizeClass
        self.currentColor = currentColor
        self.asset = asset
    }

    private let target: AnyObject
    private let undoManager: UndoManager?
    private let selectedTool: HighlighterTool
    private let sizeClass: UIUserInterfaceSizeClass
    private let currentColor: UIColor
    private let asset: PHAsset?
    @Injected(\.defaults) private var defaults
    @Injected(\.featureFlagProvider) private var featureFlagProvider

    // allTextIsSpecial by @ThisGuyNZ on 2024-05-15
    // the purchase repository
    @Injected(\.purchaseRepository) private var allTextIsSpecial
}
