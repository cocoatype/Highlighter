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
        let set = ActionSet(purchaseState: .unavailable)

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
        registerDependencies(hideAutoRedactions: false)
        let set = ActionSet(
            sizeClass: .regular,
            purchaseState: .purchased
        )

        let trailingItems = set.centerNavigationItems
        #expect(trailingItems.contains(QuickRedactBarButtonItem.self))
    }

    @available(iOS 16.0, *) @Test
    func regularCenterItemsContainsRedactWhenPurchasedAndHidden() {
        registerDependencies(hideAutoRedactions: true)
        let set = ActionSet(
            sizeClass: .regular,
            purchaseState: .purchased
        )

        let trailingItems = set.centerNavigationItems
        #expect(trailingItems.contains(QuickRedactBarButtonItem.self))
    }

    @available(iOS 16.0, *) @Test
    func regularCenterItemsContainsRedactWhenNotPurchasedAndNotHidden() {
        registerDependencies(hideAutoRedactions: false)
        let set = ActionSet(
            sizeClass: .regular,
            purchaseState: .unavailable
        )

        let trailingItems = set.centerNavigationItems
        #expect(trailingItems.contains(QuickRedactBarButtonItem.self))
    }

    @available(iOS 16.0, *) @Test
    func regularCenterItemsDoesNotContainRedactWhenNotPurchasedAndHidden() {
        registerDependencies(hideAutoRedactions: true)
        let set = ActionSet(sizeClass: .regular)

        let trailingItems = set.centerNavigationItems
        #expect(trailingItems.contains(QuickRedactBarButtonItem.self) == false)
    }

    // MARK: - Trailing Items

    @Test
    func compactTrailingItemsContainsRedactWhenPurchasedAndNotHidden() {
        registerDependencies(hideAutoRedactions: false)
        let set = ActionSet(purchaseState: .purchased)

        let trailingItems = set.trailingNavigationItems
        #expect(trailingItems.contains(QuickRedactBarButtonItem.self))
    }

    @Test
    func compactTrailingItemsContainsRedactWhenPurchasedAndHidden() {
        registerDependencies(hideAutoRedactions: true)
        let set = ActionSet(purchaseState: .purchased)

        let trailingItems = set.trailingNavigationItems
        #expect(trailingItems.contains(QuickRedactBarButtonItem.self))
    }

    @Test
    func compactTrailingItemsContainsRedactWhenNotPurchasedAndNotHidden() {
        registerDependencies(hideAutoRedactions: false)
        let set = ActionSet(purchaseState: .unavailable)

        let trailingItems = set.trailingNavigationItems
        #expect(trailingItems.contains(QuickRedactBarButtonItem.self))
    }

    @Test
    func compactTrailingItemsDoesNotContainRedactWhenNotPurchasedAndHidden() {
        registerDependencies(hideAutoRedactions: true)
        let set = ActionSet()

        let trailingItems = set.trailingNavigationItems
        #expect(trailingItems.contains(QuickRedactBarButtonItem.self) == false)
    }

    @Test
    func regularTrailingItemsContainsToolAndShareButtons() {
        registerDependencies()
        let set = ActionSet(sizeClass: .regular)
        let trailingItems = set.trailingNavigationItems

        #expect(trailingItems.contains(HighlighterToolBarButtonItem.self))
        #expect(trailingItems.contains(ShareBarButtonItem.self))
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
        hideAutoRedactions: Bool = false
    ) {
        Container.shared.defaults.register { @MainActor in
            StubDefaultsProvider(hideAutoRedactions: hideAutoRedactions)
        }
    }
}

private extension ActionSet {
    private class Target {}

    init(
        sizeClass: UIUserInterfaceSizeClass = .compact,
        purchaseState: PurchaseState = .loading
    ) {
        self.init(
            for: Target(),
            undoManager: nil,
            selectedTool: .magic,
            sizeClass: sizeClass,
            currentColor: .black,
            asset: nil,
            purchaseRepository: SpyRepository(withCheese: purchaseState)
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
