//  Created by Geoff Pado on 3/23/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import ErrorHandling
import Foundation
import Receipts

protocol Verifier {
    var hasUserPurchased: Bool { get async }
}

public struct PurchaseVerifier: Verifier {
    private let versionFetchingMethod: () async throws -> String
    private let purchaseVerificationMethod: (String) async throws -> Bool
    public init(
        versionFetchingMethod: @escaping (() async throws -> String) = { try await ReceiptValidator.originalAppVersion },
        purchaseVerificationMethod: @escaping ((String) async throws -> Bool) = ReceiptValidator.hasPurchasedProduct(withIdentifier:)
    ) {
        self.versionFetchingMethod = versionFetchingMethod
        self.purchaseVerificationMethod = purchaseVerificationMethod
    }

    public var hasUserPurchased: Bool {
        get async {
            guard ProcessInfo.processInfo.environment.keys.contains("OVERRIDE_PURCHASE") == false else {
                return false
            }

            do {
                // get the version that the user first downloaded
                let originalPurchaseVersion = try await Int(versionFetchingMethod()) ?? Int.max

                // if it's earlier than the cutoff, they bought when the app cost up-front
                guard originalPurchaseVersion >= Self.freeProductCutoff else { return true }

                // check if the user bought the IAP
                return try await purchaseVerificationMethod(PurchaseConstants.productIdentifier)
            } catch {
                ErrorHandler().log(error)
                return true
            }
        }
    }

    private static let freeProductCutoff = 200 // arbitrary build in between 19.3 and 19.4
}
