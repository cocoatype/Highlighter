//  Created by Geoff Pado on 8/18/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation
import OpenSSL

extension AppReceipt {

    init(startingAt cursor: inout UnsafePointer<UInt8>, payloadLength: Int) throws {
        let endOfPayload = cursor.advanced(by: payloadLength)

        var type = Int32(0)
        var xclass = Int32(0)
        var length = 0

        ASN1_get_object(&(cursor.optional), &length, &type, &xclass, payloadLength)

        guard type == V_ASN1_SET else { throw ReceiptParserError.malformedReceipt }

        var bundleIdentifier: String?
        var bundleIdentifierData: Data?
        var appVersion: String?
        var opaqueValue: Data?
        var sha1Hash: Data?
        var purchaseReceipts = [PurchaseReceipt]()
        var originalAppVersion: String?
        var receiptCreationDate: Date?
        var expirationDate: Date?

        while cursor < endOfPayload {
            ASN1_get_object(&(cursor.optional), &length, &type, &xclass, cursor.distance(to: endOfPayload))
            guard type == V_ASN1_SEQUENCE else { throw ReceiptParserError.malformedReceipt }

            let attributeType = ReceiptAttributeType(startingAt: &(cursor.optional), length: cursor.distance(to: endOfPayload))
            guard Int(startingAt: &(cursor.optional), length: cursor.distance(to: endOfPayload)) != nil else { throw ReceiptParserError.malformedReceipt }

            ASN1_get_object(&(cursor.optional), &length, &type, &xclass, cursor.distance(to: endOfPayload))

            guard type == V_ASN1_OCTET_STRING else { throw ReceiptParserError.malformedReceipt }

            switch attributeType {
            case .bundleIdentifier?:
                var start = cursor.optional
                bundleIdentifierData = Data(bytes: &start, count: length)
                bundleIdentifier = String(startingAt: &start, length: length)
            case .appVersion?:
                var start = cursor.optional
                appVersion = String(startingAt: &start, length: length)
            case .opaqueValue?:
                var start = cursor.optional
                opaqueValue = Data(bytes: &start, count: length)
            case .sha1Hash?:
                var start = cursor.optional
                sha1Hash = Data(bytes: &start, count: length)
            case .purchaseReceipt?:
                var start = cursor.optional
                try purchaseReceipts.append(PurchaseReceipt(startingAt: &start, payloadLength: length))
            case .receiptCreationDate?:
                var start = cursor.optional
                receiptCreationDate = Date(startingAt: &start, length: length)
            case .originalAppVersion?:
                var start = cursor.optional
                originalAppVersion = String(startingAt: &start, length: length)
            case .expirationDate?:
                var start = cursor.optional
                expirationDate = Date(startingAt: &start, length: length)
            case .none:
                break
            }

            cursor = cursor.advanced(by: length)
        }

        self = try AppReceipt(bundleIdentifier: bundleIdentifier, bundleIdentifierData: bundleIdentifierData, appVersion: appVersion, opaqueValue: opaqueValue, sha1Hash: sha1Hash, purchaseReceipts: purchaseReceipts, originalAppVersion: originalAppVersion, receiptCreationDate: receiptCreationDate, expirationDate: expirationDate)
    }
}
