//  Created by Geoff Pado on 8/11/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation
import StoreKit

enum PurchaseState {
    case unknown
    case loading
    case readyForPurchase(product: SKProduct)
    case purchasing(transaction: SKPaymentTransaction)
    case purchased
    case unavailable
}
