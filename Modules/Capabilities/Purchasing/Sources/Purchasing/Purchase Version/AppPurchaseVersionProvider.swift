//  Created by Geoff Pado on 5/18/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import StoreKit

import FactoryKit

import ErrorHandling

@available(iOS 16.0, *)
struct AppPurchaseVersionProvider: PurchaseVersionProvider {
    @Injected(\.errorHandler) private var errorHandler
    var originalPurchaseVersion: Int {
        get async {
            do {
                // Mac returns the marketing version instead of the build version
                // but the Mac app never gets the grandfathered support anyway
                #if DEBUG || targetEnvironment(macCatalyst)
                return .max
                #else
                let appTransaction = try await AppTransaction.shared.payloadValue
                let versionString = appTransaction.originalAppVersion
                guard let version = Int(versionString) else {
                    throw PurchaseError.unparseableAppVersion(version: versionString)
                }

                return version
                #endif
            } catch {
                errorHandler.log(error,
                                 module: "Purchasing",
                                 type: "AppPurchaseVersionProvider")
                return .max
            }
        }
    }
}
