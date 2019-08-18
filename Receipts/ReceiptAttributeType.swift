//  Created by Geoff Pado on 8/18/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import OpenSSL

enum ReceiptAttributeType {
    case bundleIdentifier
    case appVersion
    case opaqueValue
    case sha1Hash
    case purchaseReceipt
    case receiptCreationDate
    case originalAppVersion
    case expirationDate

    init?(startingAt intPointer: inout UnsafePointer<UInt8>?, length: Int) {
        var type = Int32(0)
        var xclass = Int32(0)
        var intLength = 0

        ASN1_get_object(&intPointer, &intLength, &type, &xclass, length)

        guard type == V_ASN1_INTEGER else { return nil }
        let integer = c2i_ASN1_INTEGER(nil, &intPointer, intLength)
        let result = ASN1_INTEGER_get(integer)
        ASN1_INTEGER_free(integer)

        switch result {
        case 2: self = .bundleIdentifier
        case 3: self = .appVersion
        case 4: self = .opaqueValue
        case 5: self = .sha1Hash
        case 17: self = .purchaseReceipt
        case 12: self = .receiptCreationDate
        case 19: self = .originalAppVersion
        case 21: self = .expirationDate
        default: return nil
        }
    }
}
