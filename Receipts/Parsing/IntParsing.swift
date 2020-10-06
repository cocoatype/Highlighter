//  Created by Geoff Pado on 8/18/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation
import OpenSSL

extension Int {
    init?(startingAt intPointer: inout UnsafePointer<UInt8>?, length: Int) {
        let integer = d2i_ASN1_INTEGER(nil, &intPointer, length)
        self = ASN1_INTEGER_get(integer)
        ASN1_INTEGER_free(integer)
    }
}
