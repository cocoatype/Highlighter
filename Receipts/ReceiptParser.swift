//  Created by Geoff Pado on 8/18/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import OpenSSL

class ReceiptParser {
    func parse(container: UnsafeMutablePointer<PKCS7>) throws -> AppReceipt {
        guard let contents = container.pointee.d.sign.pointee.contents,
          let octets = contents.pointee.d.data,
          var cursor = UnsafePointer(octets.pointee.data)
        else {
            throw ReceiptParserError.malformedReceipt
        }

        let payloadLength = Int(octets.pointee.length)
        return try AppReceipt(startingAt: &cursor, payloadLength: payloadLength)
    }
}
