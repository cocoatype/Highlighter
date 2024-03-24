//  Created by Geoff Pado on 8/11/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import ErrorHandling
import StoreKit
import UIKit

public enum ReceiptValidator {
    public static var originalAppVersion: String {
        get async throws {
            switch try await AppTransaction.shared {
            case .unverified(_, let verificationError):
                throw verificationError
            case .verified(let transaction):
                transaction.originalAppVersion
            }
        }
    }

    public static func hasPurchasedProduct(withIdentifier identifier: String) async throws -> Bool {
        guard let product = try await Product.products(for: [identifier]).first else { throw ReceiptValidationError.cannotFetchProduct }
        guard let result = await product.latestTransaction else { return false }

        switch result {
        case .verified:
            return true
        case .unverified(_, let verificationError):
            throw verificationError
        }
    }
}

public enum ReceiptValidationError: Error {
    case cannotFetchProduct
}
