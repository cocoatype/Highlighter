//  Created by Geoff Pado on 9/1/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation
import XCTest

@testable import Core
@testable import Receipts

class PurchaseValidatorTests: XCTestCase {
    func testFreeUnlockIfAppWasPurchasedEarly() throws {
        let receiptFetchingMethod: (() throws -> AppReceipt) = {
            return try self.appReceipt(withVersion: "100")
        }

        let wasPurchased = try PreviousPurchasePublisher.hasUserPurchasedProduct(receiptFetchingMethod: receiptFetchingMethod).get()

        XCTAssertTrue(wasPurchased)
    }

    func testFreeUnlockIfAppWasPurchasedLate() throws {
        let receiptFetchingMethod: (() throws -> AppReceipt) = {
            return try self.appReceipt(withVersion: "1000")
        }

        let wasPurchased = try PreviousPurchasePublisher.hasUserPurchasedProduct(receiptFetchingMethod: receiptFetchingMethod).get()
        XCTAssertFalse(wasPurchased)
    }

    private func appReceipt(withVersion version: String) throws -> AppReceipt {
        return try AppReceipt(bundleIdentifier: "com.cocoatype.Highlighter", bundleIdentifierData: Data(), appVersion: "5000", opaqueValue: Data(), sha1Hash: Data(), purchaseReceipts: [], originalAppVersion: version, receiptCreationDate: Date(), expirationDate: Date())
    }
}
