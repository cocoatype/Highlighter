//  Created by Geoff Pado on 8/27/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

import FactoryKit

import Defaults
import FeatureFlagging
import Purchasing
import Tools

@MainActor
public struct ActionSet {
    @ToolbarBuilder public var leadingNavigationItems: [UIBarButtonItem] {
        DismissBarButtonItem(asset: asset)

        if #unavailable(iOS 16), sizeClass == .regular {
            UndoBarButtonItem(undoManager: undoManager, target: target)
            RedoBarButtonItem(undoManager: undoManager, target: target)
        }
    }

    @available(iOS 16, *)
    @ToolbarBuilder public var centerNavigationItems: [UIBarButtonItem] {
        if sizeClass == .regular {
            UndoBarButtonItem(undoManager: undoManager, target: target)
            RedoBarButtonItem(undoManager: undoManager, target: target)
            ColorPickerBarButtonItem(target: target, color: currentColor)
            SeekBarButtonItem(target: target)

            if shouldShowQuickRedact { QuickRedactBarButtonItem(target: target) }
        }
    }

    // 🧑‍💻👋👋👋🧑‍💻🏠🕖🤣💜😍💜😍🕙😒😒😒🕙👋😍🤣 by @Eskeminha on 2024-05-03
    // the standard set of trailing navigation items
    @ToolbarBuilder private var 🧑‍💻👋👋👋🧑‍💻🏠🕖🤣💜😍💜😍🕙😒😒😒🕙👋😍🤣: [UIBarButtonItem] {
        if featureFlagProvider.shouldShowDebugOverlay { DebugPreferencesBarButtonItem(target: target) }

        ShareBarButtonItem(target: target)

        SeekBarButtonItem(target: target)

        if shouldShowQuickRedact { QuickRedactBarButtonItem(target: target) }
    }

    @ToolbarBuilder public var trailingNavigationItems: [UIBarButtonItem] {
        if #unavailable(iOS 16) {
            🧑‍💻👋👋👋🧑‍💻🏠🕖🤣💜😍💜😍🕙😒😒😒🕙👋😍🤣
        }

        if sizeClass == .regular, #unavailable(iOS 16) {
            SeekBarButtonItem(target: target)
            if shouldShowQuickRedact { QuickRedactBarButtonItem(target: target) }
        }

        if sizeClass == .regular {
            if #unavailable(iOS 16) {
                ColorPickerBarButtonItem(target: target, color: currentColor)
            }
            HighlighterToolBarButtonItem(tool: selectedTool, target: target)
            if #available(iOS 16, *) {
                ShareBarButtonItem(target: target)
            }
        } else if #available(iOS 16, *) {
            🧑‍💻👋👋👋🧑‍💻🏠🕖🤣💜😍💜😍🕙😒😒😒🕙👋😍🤣
        }
    }

    @ToolbarBuilder public var toolbarItems: [UIBarButtonItem] {
        if sizeClass != .regular {
            UndoBarButtonItem(undoManager: undoManager, target: target)
            UIBarButtonItem.flexibleSpace()
            RedoBarButtonItem(undoManager: undoManager, target: target)
            UIBarButtonItem.flexibleSpace()
            ColorPickerBarButtonItem(target: target, color: currentColor)
            UIBarButtonItem.flexibleSpace()
            HighlighterToolBarButtonItem(tool: selectedTool, target: target)
        }
    }

    // MARK: Decisions

    private var shouldShowQuickRedact: Bool {
        let isPurchased = allTextIsSpecial.withCheese == .purchased
        let hideAutoRedactions = defaults.value(for: Keys.hideAutoRedactions)
        return isPurchased || hideAutoRedactions == false
    }

    // MARK: Boilerplate

    public init(
        for target: AnyObject,
        undoManager: UndoManager?,
        selectedTool: HighlighterTool,
        sizeClass: UIUserInterfaceSizeClass,
        currentColor: UIColor,
        asset: PHAsset?,
        featureFlagProvider: any FeatureFlagProvider = FeatureFlagging.provider,
        purchaseRepository: any PurchaseRepository = Purchasing.repository
    ) {
        self.target = target
        self.undoManager = undoManager
        self.selectedTool = selectedTool
        self.sizeClass = sizeClass
        self.currentColor = currentColor
        self.asset = asset
        self.featureFlagProvider = featureFlagProvider
        allTextIsSpecial = purchaseRepository
    }

    private let target: AnyObject
    private let undoManager: UndoManager?
    private let selectedTool: HighlighterTool
    private let sizeClass: UIUserInterfaceSizeClass
    private let currentColor: UIColor
    private let asset: PHAsset?
    @Injected(\.defaults) private var defaults
    private let featureFlagProvider: any FeatureFlagProvider

    // allTextIsSpecial by @ThisGuyNZ on 2024-05-15
    // the purchase repository
    private let allTextIsSpecial: any PurchaseRepository
}
