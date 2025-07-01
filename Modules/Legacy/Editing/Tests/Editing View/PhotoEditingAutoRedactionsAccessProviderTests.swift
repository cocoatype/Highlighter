//  Created by Geoff Pado on 5/15/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import AutoRedactionsUI
import PurchasingDoubles
import XCTest

@testable import Editing

@MainActor
class PhotoEditingAutoRedactionsAccessProviderTests: XCTestCase {
    func testAutoRedactionsAccessViewControllerIsNavigationControllerWhenPurchased() {
        let provider = PhotoEditingAutoRedactionsAccessProvider(purchaseRepository: PreviewRepository(purchaseState: .purchased))

        XCTAssert(provider.autoRedactionsAccessViewController {} is AutoRedactionsAccessNavigationController)
    }

    func testAutoRedactionsAccessViewControllerIsAlertControllerWhenNotPurchased() {
        let provider = PhotoEditingAutoRedactionsAccessProvider(purchaseRepository: PreviewRepository(purchaseState: .unavailable))

        XCTAssert(provider.autoRedactionsAccessViewController {} is UIAlertController)
    }
}
