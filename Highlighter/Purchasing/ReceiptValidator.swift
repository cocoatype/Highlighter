//  Created by Geoff Pado on 8/11/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation

class ReceiptValidator {
    var appReceiptStatus: ReceiptStatus { return .valid }
    var unlockPurchaseStatus: ReceiptStatus {
        guard FileManager.default.fileExists(atPath: ReceiptValidator.receiptURL.path) else { return .missing }
        return .valid
    }

    // MARK: Boilerplate
    private static let receiptURL: URL = {
        guard let receiptURL = Bundle.main.appStoreReceiptURL else {
            fatalError("Error locating app receipt")
        }

        return receiptURL
    }()
}

enum ReceiptStatus {
    case valid
    case invalid
    case missing
}
