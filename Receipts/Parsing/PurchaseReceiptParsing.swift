//
//  PurchaseReceiptParsing.swift
//  Receipts
//
//  Created by Geoff Pado on 8/18/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.
//

import Foundation
import OpenSSL

extension PurchaseReceipt {
    init(startingAt cursor: inout UnsafePointer<UInt8>?, payloadLength: Int) throws {
        var quantity: Int?
        var productIdentifier: String?
        var transactionIdentifier: String?
        var originalTransactionIdentifier: String?
        var purchaseDate: Date?
        var originalPurchaseDate: Date?
        var subscriptionExpirationDate: Date?
        var cancellationDate: Date?
        var webOrderLineItemId: Int?

        guard var cursor = cursor else { throw ReceiptParserError.malformedReceipt }
        let endOfPayload = cursor.advanced(by: payloadLength)
        var type = Int32(0)
        var xclass = Int32(0)
        var length = 0

        ASN1_get_object(&(cursor.optional), &length, &type, &xclass, payloadLength)
        guard type == V_ASN1_SET else { throw ReceiptParserError.malformedReceipt }

        while cursor < endOfPayload {
            ASN1_get_object(&(cursor.optional), &length, &type, &xclass, cursor.distance(to: endOfPayload))
            guard type == V_ASN1_SEQUENCE else { throw ReceiptParserError.malformedReceipt }

            let attributeType = PurchaseReceiptAttributeType(startingAt: &(cursor.optional), length: cursor.distance(to: endOfPayload))
            guard Int(startingAt: &(cursor.optional), length: cursor.distance(to: endOfPayload)) != nil else { throw ReceiptParserError.malformedReceipt }

            ASN1_get_object(&(cursor.optional), &length, &type, &xclass, cursor.distance(to: endOfPayload))
            guard type == V_ASN1_OCTET_STRING else { throw ReceiptParserError.malformedReceipt }

            switch attributeType {
            case .quantity?:
                var start = cursor.optional
                quantity = Int(startingAt: &start, length: length)
            case .productIdentifier?:
                var start = cursor.optional
                productIdentifier = String(startingAt: &start, length: length)
            case .transactionIdentifier?:
                var start = cursor.optional
                transactionIdentifier = String(startingAt: &start, length: length)
            case .originalTransactionIdentifier?:
                var start = cursor.optional
                originalTransactionIdentifier = String(startingAt: &start, length: length)
            case .purchaseDate?:
                var start = cursor.optional
                purchaseDate = Date(startingAt: &start, length: length)
            case .originalPurchaseDate?:
                var start = cursor.optional
                originalPurchaseDate = Date(startingAt: &start, length: length)
            case .subscriptionExpirationDate?:
                var start = cursor.optional
                subscriptionExpirationDate = Date(startingAt: &start, length: length)
            case .cancellationDate?:
                var start = cursor.optional
                cancellationDate = Date(startingAt: &start, length: length)
            case .webOrderLineItemId?:
                var start = cursor.optional
                webOrderLineItemId = Int(startingAt: &start, length: length)
            case .none: break
            }

            cursor = cursor.advanced(by: length)
        }

        self = try PurchaseReceipt(quantity: quantity, productIdentifier: productIdentifier, transactionIdentifier: transactionIdentifier, originalTransactionIdentifier: originalTransactionIdentifier, purchaseDate: purchaseDate, originalPurchaseDate: originalPurchaseDate, subscriptionExpirationDate: subscriptionExpirationDate, cancellationDate: cancellationDate, webOrderLineItemId: webOrderLineItemId)
    }
}
