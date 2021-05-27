//  Created by Geoff Pado on 8/17/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import StoreKit

enum PurchaseOperationTarget {
    case product(SKProduct)
    case identifier(String)

    var product: SKProduct? {
        switch self {
        case .identifier: return nil
        case .product(let product): return product
        }
    }

    var identifier: String {
        switch self {
        case .identifier(let identifier): return identifier
        case .product(let product): return product.productIdentifier
        }
    }
}
