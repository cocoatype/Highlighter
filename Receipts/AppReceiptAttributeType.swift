//  Created by Geoff Pado on 8/18/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import OpenSSL

enum AppReceiptAttributeType {
    case bundleIdentifier
    case appVersion
    case opaqueValue
    case sha1Hash
    case purchaseReceipt
    case receiptCreationDate
    case originalAppVersion
    case expirationDate

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
