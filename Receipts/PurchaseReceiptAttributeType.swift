//  Created by Geoff Pado on 8/18/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import OpenSSL

enum PurchaseReceiptAttributeType {
        case quantity
        case productIdentifier
        case transactionIdentifier
        case originalTransactionIdentifier
        case purchaseDate
        case originalPurchaseDate
        case subscriptionExpirationDate
        case cancellationDate
        case webOrderLineItemId

        init?(startingAt intPointer: inout UnsafePointer<UInt8>?, length: Int) {
            var type = Int32()
            var xclass = Int32()
            var intLength = 0

            var startingPointer = UnsafePointer(intPointer)

            ASN1_get_object(&intPointer, &intLength, &type, &xclass, length)
            guard type == V_ASN1_INTEGER else { return nil }

            guard let movedPointer = intPointer, let initialPointer = startingPointer else { return nil }
            let difference = movedPointer - initialPointer

            let integer = d2i_ASN1_INTEGER(nil, &startingPointer, difference + intLength)
            let result = ASN1_INTEGER_get(integer)
            ASN1_INTEGER_free(integer)

            intPointer = startingPointer

            switch result {
            case 1701: self = .quantity
            case 1702: self = .productIdentifier
            case 1703: self = .transactionIdentifier
            case 1705: self = .originalTransactionIdentifier
            case 1704: self = .purchaseDate
            case 1706: self = .originalPurchaseDate
            case 1708: self = .subscriptionExpirationDate
            case 1712: self = .cancellationDate
            case 1711: self = .webOrderLineItemId
            default: return nil
            }
        }
    }
