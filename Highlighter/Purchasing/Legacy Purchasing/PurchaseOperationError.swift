//  Created by Geoff Pado on 8/17/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

enum PurchaseOperationError: Error {
    case paymentsNotAvailable
    case productNotFound(identifier: String)
    case unknown
}
