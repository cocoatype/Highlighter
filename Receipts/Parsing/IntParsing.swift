//  Created by Geoff Pado on 8/18/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation
import OpenSSL

extension Int {
    init?(startingAt intPointer: inout UnsafePointer<UInt8>?, length: Int) {
        var type = Int32(0)
        var xclass = Int32(0)
        var intLength = 0

        ASN1_get_object(&intPointer, &intLength, &type, &xclass, length)

        guard type == V_ASN1_INTEGER else { return nil }
        let integer = c2i_ASN1_INTEGER(nil, &intPointer, intLength)
        self = ASN1_INTEGER_get(integer)
        ASN1_INTEGER_free(integer)
    }
}
