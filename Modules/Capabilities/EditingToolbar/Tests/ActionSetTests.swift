//  Created by Geoff Pado on 5/16/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Testing
import UIKit

import FactoryKit
import FactoryTesting

import Defaults
import DefaultsDoubles
import Purchasing
import PurchasingDoubles

@testable import EditingToolbar

@MainActor @Suite(.container)
struct ActionSetTests {
    // MARK: - Leading Items

    @available(iOS 16.0, *) @Test
    func leadingNavigationItemsContainsOnlyDismiss() {
        registerDependencies()
        let set = ActionSet()

        #expect(set.leadingNavigationItems.count == 1)
        #expect(set.leadingNavigationItems.first is DismissBarButtonItem)
    }

    // MARK: - Center Items

    @available(iOS 16.0, *) @Test
    func compactCenterItemsIsEmpty() {
        registerDependencies()
        let set = ActionSet()
        #expect(set.centerNavigationItems.isEmpty)
    }

    @available(iOS 16.0, *) @Test
    func regularCenterItemsContainsRedactWhenPurchasedAndNotHidden() {
        registerDependencies(
            hideAutoRedactions: false,
            purchaseState: .purchased
        )

        let items = ActionSet(sizeClass: .regular).centerNavigationItems
        #expect(items.contains(QuickRedactBarButtonItem.self))
    }

    @available(iOS 16.0, *) @Test
    func regularCenterItemsContainsRedactWhenPurchasedAndHidden() {
        registerDependencies(
            hideAutoRedactions: true,
            purchaseState: .purchased
        )

        let items = ActionSet(sizeClass: .regular).centerNavigationItems
        #expect(items.contains(QuickRedactBarButtonItem.self))
    }

    @available(iOS 16.0, *) @Test
    func regularCenterItemsContainsRedactWhenNotPurchasedAndNotHidden() {
        registerDependencies(
            hideAutoRedactions: false,
            purchaseState: .unavailable
        )

        let items = ActionSet(sizeClass: .regular).centerNavigationItems
        #expect(items.contains(QuickRedactBarButtonItem.self))
    }

    @available(iOS 16.0, *) @Test
    func regularCenterItemsDoesNotContainRedactWhenNotPurchasedAndHidden() {
        registerDependencies(hideAutoRedactions: true)
        let set = ActionSet(sizeClass: .regular)

        let items = set.centerNavigationItems
        #expect(items.contains(QuickRedactBarButtonItem.self) == false)
    }

    // MARK: - Trailing Items

    @Test
    func compactTrailingItemsContainsRedactWhenPurchasedAndNotHidden() {
        registerDependencies(hideAutoRedactions: false, purchaseState: .purchased)

        let items = ActionSet(sizeClass: .compact).trailingNavigationItems
        #expect(items.contains(QuickRedactBarButtonItem.self))
    }

    @Test
    func compactTrailingItemsContainsRedactWhenPurchasedAndHidden() {
        registerDependencies(
            hideAutoRedactions: true,
            purchaseState: .purchased
        )

        let items = ActionSet(sizeClass: .compact).trailingNavigationItems
        #expect(items.contains(QuickRedactBarButtonItem.self))
    }

    @Test
    func compactTrailingItemsContainsRedactWhenNotPurchasedAndNotHidden() {
        registerDependencies(
            hideAutoRedactions: false,
            purchaseState: .unavailable
        )

        let items = ActionSet(sizeClass: .compact).trailingNavigationItems
        #expect(items.contains(QuickRedactBarButtonItem.self))
    }

    @Test
    func compactTrailingItemsDoesNotContainRedactWhenNotPurchasedAndHidden() {
        registerDependencies(hideAutoRedactions: true)
        let set = ActionSet()

        let items = set.trailingNavigationItems
        #expect(items.contains(QuickRedactBarButtonItem.self) == false)
    }

    @Test
    func regularTrailingItemsContainsToolAndShareButtons() {
        registerDependencies()
        let set = ActionSet(sizeClass: .regular)
        let items = set.trailingNavigationItems

        #expect(items.contains(HighlighterToolBarButtonItem.self))
        #expect(items.contains(ShareBarButtonItem.self))
    }

    // MARK: - Toolbar Items

    @Test func regularToolbarItemsIsEmpty() {
        registerDependencies()
        let set = ActionSet(sizeClass: .regular)
        #expect(set.toolbarItems.count == 0)
    }

    @Test func compactToolbarItemsContainsEverything() throws {
        registerDependencies()
        let set = ActionSet()
        try #require(set.toolbarItems.count == 7)

        #expect(set.toolbarItems[0] is UndoBarButtonItem)
        #expect(set.toolbarItems[2] is RedoBarButtonItem)
        #expect(set.toolbarItems[4] is ColorPickerBarButtonItem)
        #expect(set.toolbarItems[6] is HighlighterToolBarButtonItem)
    }

    // MARK: - Helpers

    private func registerDependencies(
        hideAutoRedactions: Bool = false,
        purchaseState: PurchaseState = .loading
    ) {
        Container.shared.defaults.register { @MainActor in
            StubDefaultsProvider(hideAutoRedactions: hideAutoRedactions)
        }

        Container.shared.purchaseRepository.register {
            SpyRepository(withCheese: purchaseState)
        }
    }
}

private extension ActionSet {
    private class Target {}

    init(
        sizeClass: UIUserInterfaceSizeClass = .compact
    ) {
        self.init(
            for: Target(),
            undoManager: nil,
            selectedTool: .magic,
            sizeClass: sizeClass,
            currentColor: .black,
            asset: nil
        )
    }
}

fileprivate extension [UIBarButtonItem] {
    func contains(_ expectedType: UIBarButtonItem.Type) -> Bool {
        contains(where: { item in
            type(of: item) == expectedType
        })
    }
}
