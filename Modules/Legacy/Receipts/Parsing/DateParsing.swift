//  Created by Geoff Pado on 8/18/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation

extension Date {
    init?(startingAt datePointer: inout UnsafePointer<UInt8>?, length: Int) {
        // Date formatter code from https://www.objc.io/issues/17-security/receipt-validation/#parsing-the-receipt
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        guard let dateString = String(startingAt: &datePointer, length:length), let date = dateFormatter.date(from: dateString) else { return nil }

        self = date
    }
}
