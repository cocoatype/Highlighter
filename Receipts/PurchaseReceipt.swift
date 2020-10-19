//  Created by Geoff Pado on 8/18/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation

public struct PurchaseReceipt {
    let quantity: Int
    public let productIdentifier: String
    let transactionIdentifier: String
    let originalTransactionIdentifier: String?
    let purchaseDate: Date?
    let originalPurchaseDate: Date?
    let subscriptionExpirationDate: Date?
    let cancellationDate: Date?
    let webOrderLineItemId: Int?

    init(quantity: Int?, productIdentifier: String?, transactionIdentifier: String?, originalTransactionIdentifier: String?, purchaseDate: Date?, originalPurchaseDate: Date?, subscriptionExpirationDate: Date?, cancellationDate: Date?, webOrderLineItemId: Int?) throws {
        guard
          let productIdentifier = productIdentifier,
          let transactionIdentifier = transactionIdentifier
        else { throw ReceiptParserError.incompleteData }

        self.quantity = quantity ?? 1
        self.productIdentifier = productIdentifier
        self.transactionIdentifier = transactionIdentifier
        self.originalTransactionIdentifier = originalTransactionIdentifier
        self.purchaseDate = purchaseDate
        self.originalPurchaseDate = originalPurchaseDate
        self.subscriptionExpirationDate = subscriptionExpirationDate
        self.cancellationDate = cancellationDate
        self.webOrderLineItemId = webOrderLineItemId
    }
}
