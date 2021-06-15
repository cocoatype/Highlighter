//  Created by Geoff Pado on 5/21/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Combine
import Receipts

struct PreviousPurchasePublisher: Publisher {
    typealias Output = Bool
    typealias Failure = Error

    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        Result.Publisher(Self.hasUserPurchasedProduct()).subscribe(subscriber)
    }

    // MARK: Purchase Validation

    static func hasUserPurchasedProduct(receiptFetchingMethod: (() throws -> AppReceipt) = ReceiptValidator.validatedAppReceipt) -> Result<Bool, Error> {
        do {
            let receipt = try receiptFetchingMethod()
            let originalPurchaseVersion = Int(receipt.purchaseVersion) ?? Int.max
            let earnedFreeProduct = originalPurchaseVersion < Self.freeProductCutoff
            let purchasedProduct = receipt.containsPurchase(withIdentifier: PurchaseConstants.productIdentifier)
            let userHasProduct = earnedFreeProduct || purchasedProduct
            return .success(userHasProduct)
        } catch {
            dump(error)
            return .failure(error)
        }
    }

    private static let freeProductCutoff = 200 // arbitrary build in between 19.3 and 19.4
}