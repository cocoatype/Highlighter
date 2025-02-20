//  Created by Geoff Pado on 5/18/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import StoreKit

@available(iOS 15.0, *)
struct StoreProductProvider: ProductProvider {
    var products: [any PurchaseProduct] {
        get async throws {
            return try await Product.products(for: [
                PurchaseConstants.oneTimeProductIdentifier,
                PurchaseConstants.annualProductIdentifier,
                PurchaseConstants.monthlyProductIdentifier,
            ])
        }
    }
}
