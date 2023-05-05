//  Created by Geoff Pado on 8/11/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation
import StoreKit

enum PurchaseState {
    case loading
    case readyForPurchase(product: SKProduct)
    case purchasing//(operation: PurchaseOperation)
    case restoring//(operation: RestoreOperation)
    case purchased
    case unavailable

    var product: SKProduct? {
        switch self {
        case .readyForPurchase(let product): return product
        default: return nil
        }
    }
}
