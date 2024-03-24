//  Created by Geoff Pado on 9/1/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation
import XCTest

@testable import Purchasing
@testable import Receipts

class PurchaseValidatorTests: XCTestCase {
    func testHasUserPurchasedProductReturnsTrueIfBeforeCutoff() async throws {
        let wasPurchased = try await PreviousPurchasePublisher.hasUserPurchasedProduct {
            "100"
        } purchaseVerificationMethod: { _ in false }

        XCTAssertTrue(wasPurchased)
    }

    func testHasUserPurchasedProductReturnsFalseIfAfterCutoff() async throws {
        let wasPurchased = try await PreviousPurchasePublisher.hasUserPurchasedProduct {
            "1000"
        } purchaseVerificationMethod: { _ in false }

        XCTAssertFalse(wasPurchased)
    }

    func testHasUserPurchasedProductReturnsFalseIfVersionIsNotInt() async throws {
        let wasPurchased = try await PreviousPurchasePublisher.hasUserPurchasedProduct {
            "string"
        } purchaseVerificationMethod: { _ in false }

        XCTAssertFalse(wasPurchased)
    }

    func testHasUserPurchasedProductReturnsTrueIfErrorOccurs() async throws {
        let wasPurchased = try await PreviousPurchasePublisher.hasUserPurchasedProduct {
            throw NSError(domain: "", code: 0)
        } purchaseVerificationMethod: { _ in false }

        XCTAssertTrue(wasPurchased)
    }
}
