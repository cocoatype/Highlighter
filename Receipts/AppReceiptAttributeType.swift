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
        let integer = d2i_ASN1_INTEGER(nil, &intPointer, length)
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
