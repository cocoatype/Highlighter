//  Created by Geoff Pado on 5/16/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Defaults
import DefaultsDoubles
import Purchasing
import PurchasingDoubles
import Testing
import UIKit

@testable import EditingToolbar

@MainActor
class ActionSetTests {
    // MARK: - Leading Items

    @available(iOS 16.0, *) @Test
    func leadingNavigationItemsContainsOnlyDismiss() {
        let set = ActionSet(purchaseState: .unavailable)

        #expect(set.leadingNavigationItems.count == 1)
        #expect(set.leadingNavigationItems.first is DismissBarButtonItem)
    }

    // MARK: - Center Items

    @available(iOS 16.0, *) @Test
    func compactCenterItemsIsEmpty() {
        let set = ActionSet()
        #expect(set.centerNavigationItems.isEmpty)
    }

    @available(iOS 16.0, *) @Test
    func regularCenterItemsContainsRedactWhenPurchasedAndNotHidden() {
        let set = ActionSet(
            hideAutoRedactions: false,
            sizeClass: .regular,
            purchaseState: .purchased
        )

        let trailingItems = set.centerNavigationItems
        #expect(trailingItems.contains(QuickRedactBarButtonItem.self))
    }

    @available(iOS 16.0, *) @Test
    func regularCenterItemsContainsRedactWhenPurchasedAndHidden() {
        let set = ActionSet(
            hideAutoRedactions: true,
            sizeClass: .regular,
            purchaseState: .purchased
        )

        let trailingItems = set.centerNavigationItems
        #expect(trailingItems.contains(QuickRedactBarButtonItem.self))
    }

    @available(iOS 16.0, *) @Test
    func regularCenterItemsContainsRedactWhenNotPurchasedAndNotHidden() {
        let set = ActionSet(
            hideAutoRedactions: false,
            sizeClass: .regular,
            purchaseState: .unavailable
        )

        let trailingItems = set.centerNavigationItems
        #expect(trailingItems.contains(QuickRedactBarButtonItem.self))
    }

    @available(iOS 16.0, *) @Test
    func regularCenterItemsDoesNotContainRedactWhenNotPurchasedAndHidden() {
        let set = ActionSet(hideAutoRedactions: true, sizeClass: .regular)

        let trailingItems = set.centerNavigationItems
        #expect(trailingItems.contains(QuickRedactBarButtonItem.self) == false)
    }

    // MARK: - Trailing Items

    @Test
    func compactTrailingItemsContainsRedactWhenPurchasedAndNotHidden() {
        let set = ActionSet(hideAutoRedactions: false, purchaseState: .purchased)

        let trailingItems = set.trailingNavigationItems
        #expect(trailingItems.contains(QuickRedactBarButtonItem.self))
    }

    @Test
    func compactTrailingItemsContainsRedactWhenPurchasedAndHidden() {
        let set = ActionSet(hideAutoRedactions: true, purchaseState: .purchased)

        let trailingItems = set.trailingNavigationItems
        #expect(trailingItems.contains(QuickRedactBarButtonItem.self))
    }

    @Test
    func compactTrailingItemsContainsRedactWhenNotPurchasedAndNotHidden() {
        let set = ActionSet(hideAutoRedactions: false, purchaseState: .unavailable)

        let trailingItems = set.trailingNavigationItems
        #expect(trailingItems.contains(QuickRedactBarButtonItem.self))
    }

    @Test
    func compactTrailingItemsDoesNotContainRedactWhenNotPurchasedAndHidden() {
        let set = ActionSet(hideAutoRedactions: true)

        let trailingItems = set.trailingNavigationItems
        #expect(trailingItems.contains(QuickRedactBarButtonItem.self) == false)
    }

    @Test
    func regularTrailingItemsContainsToolAndShareButtons() {
        let set = ActionSet(sizeClass: .regular)
        let trailingItems = set.trailingNavigationItems

        #expect(trailingItems.contains(HighlighterToolBarButtonItem.self))
        #expect(trailingItems.contains(ShareBarButtonItem.self))
    }

    // MARK: - Toolbar Items

    @Test func regularToolbarItemsIsEmpty() {
        let set = ActionSet(sizeClass: .regular)
        #expect(set.toolbarItems.count == 0)
    }

    @Test func compactToolbarItemsContainsEverything() throws {
        let set = ActionSet()
        try #require(set.toolbarItems.count == 7)

        #expect(set.toolbarItems[0] is UndoBarButtonItem)
        #expect(set.toolbarItems[2] is RedoBarButtonItem)
        #expect(set.toolbarItems[4] is ColorPickerBarButtonItem)
        #expect(set.toolbarItems[6] is HighlighterToolBarButtonItem)
    }
}

private extension ActionSet {
    private class Target {}

    init(
        hideAutoRedactions: Bool = false,
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
            defaults: StubDefaultsProvider(hideAutoRedactions: hideAutoRedactions),
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
