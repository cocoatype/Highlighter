//  Created by Geoff Pado on 8/11/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation
import StoreKit

public enum PurchaseState: Identifiable, Hashable {
    case loading
    case readyForPurchase(products: [any PurchaseProduct])
    case purchasing
    case restoring
    case purchased
    case unavailable

    public var products: [any PurchaseProduct]? {
        switch self {
        case .readyForPurchase(let products): return products
        default: return nil
        }
    }

    public var isReadyForPurchase: Bool {
        switch self {
        case .readyForPurchase: return true
        case .loading, .purchasing, .restoring, .purchased, .unavailable: return false
        }
    }

    public var id: Self { self }

    // MARK: Equatable

    public static func == (lhs: PurchaseState, rhs: PurchaseState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): true
        case (.readyForPurchase(let lhsProducts), .readyForPurchase(let rhsProducts)):
            lhsProducts.map(\.id) == rhsProducts.map(\.id)
        case (.purchasing, .purchasing): true
        case (.restoring, .restoring): true
        case (.purchased, .purchased): true
        case (.unavailable, .unavailable): true
        case (.loading, _): false
        case (.readyForPurchase, _): false
        case (.purchasing, _): false
        case (.restoring, _): false
        case (.purchased, _): false
        case (.unavailable, _): false
        }
    }

    // MARK: Hashable

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .readyForPurchase(let products):
            for product in products {
                hasher.combine(product)
            }
        case .loading, .purchasing, .restoring, .purchased, .unavailable:
            hasher.combine(String(describing: self))
        }
    }
}
