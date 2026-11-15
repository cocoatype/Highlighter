//  Created by Geoff Pado on 5/18/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import StoreKit

import FactoryKit

import Defaults
import ErrorHandling

@available(iOS 16.0, *)
struct AppPurchaseVersionProvider: PurchaseVersionProvider {
    typealias FetchVersion = @Sendable () async throws -> String

    init(fetchVersion: @escaping FetchVersion = { try await AppTransaction.shared.payloadValue.originalAppVersion }) {
        self.fetchVersion = fetchVersion
    }

    var originalPurchaseVersion: Int {
        get async {
            // Mac returns the marketing version instead of the build version
            // but the Mac app never gets the grandfathered support anyway
            #if DEBUG || targetEnvironment(macCatalyst)
            return .max
            #else
            return await fetchOriginalPurchaseVersion()
            #endif
        }
    }

    func fetchOriginalPurchaseVersion() async -> Int {
        // the original purchase version never changes, so once we have it,
        // don't ask StoreKit again (it fails when offline or signed out)
        if let cachedVersion = await cachedVersion {
            return cachedVersion
        }

        do {
            let versionString = try await fetchVersion()
            guard let version = Int(versionString) else {
                throw PurchaseError.unparseableAppVersion(version: versionString)
            }

            await cache(versionString)
            return version
        } catch {
            errorHandler.log(error,
                             module: "Purchasing",
                             type: "AppPurchaseVersionProvider")
            return .max
        }
    }

    @MainActor private var cachedVersion: Int? {
        Container.shared.defaults().value(for: Keys.originalPurchaseVersion).flatMap(Int.init)
    }

    @MainActor private func cache(_ versionString: String) {
        Container.shared.defaults().set(versionString, for: Keys.originalPurchaseVersion)
    }

    // MARK: Boilerplate

    @Injected(\.errorHandler) private var errorHandler
    private let fetchVersion: FetchVersion
}
