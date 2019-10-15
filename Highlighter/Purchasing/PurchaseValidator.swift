//  Created by Geoff Pado on 9/1/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation
import Receipts

struct PurchaseValidator {
    static func hasUserPurchasedProduct(withIdentifier identifier: String, receiptFetchingMethod: (() throws -> AppReceipt) = ReceiptValidator.validatedAppReceipt) -> Bool {
        do {
            let receipt = try receiptFetchingMethod()
            let originalPurchaseVersion = Int(receipt.originalAppVersion) ?? Int.max
            let earnedFreeProduct = originalPurchaseVersion < PurchaseValidator.freeProductCutoff
            let purchasedProduct = receipt.containsPurchase(withIdentifier: identifier)
            return earnedFreeProduct || purchasedProduct
        } catch {
            return false
        }
    }

    private static let freeProductCutoff = 200 // arbitrary build in between 19.3 and 19.4
}
