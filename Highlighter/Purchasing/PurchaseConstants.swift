//  Created by Geoff Pado on 5/21/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

enum PurchaseConstants {
    static let productIdentifier = "com.cocoatype.Highlighter.unlock"

    enum Error: Swift.Error {
        case paymentsNotAvailable
        case productNotFound(identifier: String)
        case unknown
    }
}
