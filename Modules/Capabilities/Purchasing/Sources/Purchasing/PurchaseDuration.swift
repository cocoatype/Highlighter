//  Created by Geoff Pado on 2/20/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

public enum PurchaseDuration: Hashable, Identifiable, Sendable {
    case monthly
    case annual
    case oneTime
    case unknown

    public var id: String {
        switch self {
        case .monthly: "monthly"
        case .annual: "annual"
        case .oneTime: "oneTime"
        case .unknown: "unknown"
        }
    }
}
