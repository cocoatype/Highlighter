//  Created by Geoff Pado on 5/17/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import ErrorHandling
import StoreKit

public protocol PurchaseProduct: Hashable, Identifiable {
    var id: String { get }
    var displayName: String { get }
    var displayPrice: String { get }
    var isPurchased: Bool { get async }

    func purchase() async throws -> Bool
}

@available(iOS 15.0, *)
extension Product: PurchaseProduct {
    public var isPurchased: Bool {
        get async {
            let entitlement = await currentEntitlement
            if case .verified = entitlement {
                return true
            } else {
                return false
            }
        }
    }

    public func purchase() async throws -> Bool {
        let result = try await purchase(options: [])
        switch result {
        case .success(let verificationResult):
            if case .verified(let transaction) = verificationResult {
                await transaction.finish()
                return true
            } else {
                fallthrough
            }
        case .userCancelled, .pending:
            fallthrough
        @unknown default:
            return false
        }
    }
}
