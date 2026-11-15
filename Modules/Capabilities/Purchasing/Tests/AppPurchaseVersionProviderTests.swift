//  Created by Geoff Pado on 11/14/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import Foundation
import Testing

import FactoryKit
import FactoryTesting

import Defaults
import DefaultsDoubles
import ErrorHandling

@testable import Purchasing

@MainActor @Suite(.container)
struct AppPurchaseVersionProviderTests {
    private let defaults = StubDefaultsProvider()
    private let errorHandler = SpyErrorHandler()

    init() {
        let defaults = defaults
        let errorHandler = errorHandler
        Container.shared.defaults.register { defaults }
        Container.shared.errorHandler.register { errorHandler }
    }

    @available(iOS 16.0, *)
    @Test("Fetched version is returned and cached")
    func fetchedVersionIsCached() async {
        let provider = AppPurchaseVersionProvider { "150" }

        #expect(await provider.fetchOriginalPurchaseVersion() == 150)
        #expect(defaults.value(for: Keys.originalPurchaseVersion) == "150")
    }

    @available(iOS 16.0, *)
    @Test("Cached version is used without asking StoreKit")
    func cachedVersionSkipsFetch() async {
        defaults.set("150", for: Keys.originalPurchaseVersion)
        let provider = AppPurchaseVersionProvider { throw TestError.shouldNotFetch }

        #expect(await provider.fetchOriginalPurchaseVersion() == 150)
        #expect(errorHandler.loggedErrorCount == 0)
    }

    @available(iOS 16.0, *)
    @Test("Failed fetch with no cache logs and is not grandfathered")
    func failedFetchFallsBack() async {
        let provider = AppPurchaseVersionProvider { throw TestError.fetchFailed }

        #expect(await provider.fetchOriginalPurchaseVersion() == .max)
        #expect(errorHandler.loggedErrorCount == 1)
        #expect(defaults.value(for: Keys.originalPurchaseVersion) == nil)
    }

    @available(iOS 16.0, *)
    @Test("Unparseable version is not cached")
    func unparseableVersionIsNotCached() async {
        let provider = AppPurchaseVersionProvider { "1.0" }

        #expect(await provider.fetchOriginalPurchaseVersion() == .max)
        #expect(errorHandler.loggedErrorCount == 1)
        #expect(defaults.value(for: Keys.originalPurchaseVersion) == nil)
    }
}

private enum TestError: Error {
    case fetchFailed
    case shouldNotFetch
}

private final class SpyErrorHandler: ErrorHandler, @unchecked Sendable {
    private let lock = NSLock()
    private var count = 0
    var loggedErrorCount: Int { lock.withLock { count } }

    func log(_ error: any Error, module: StaticString, type: StaticString) {
        lock.withLock { count += 1 }
    }

    func crash(_ message: String) -> Never { fatalError(message) }
    func notImplemented(in file: String, function: String) -> Never { fatalError() }
}
