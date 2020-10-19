//  Created by Geoff Pado on 8/18/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation
import OpenSSL

extension Int {
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
        self = ASN1_INTEGER_get(integer)
        ASN1_INTEGER_free(integer)

        intPointer = startingPointer
    }
}
