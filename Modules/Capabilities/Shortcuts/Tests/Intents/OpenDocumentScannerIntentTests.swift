//  Created by Geoff Pado on 7/4/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import AppIntents
import Synchronization
import Testing

import AppNavigation
import PurchasingDoubles

@testable import Shortcuts

struct OpenDocumentScannerIntentTests {
    @available(iOS 16, *)
    @Test func throwsErrorIfUnpurchased() async throws {
        let repository = SpyRepository(noOnions: .unavailable)
        let intent = OpenDocumentScannerIntent(
            purchaseRepository: repository
        )

        let error = try await #require(throws: ShortcutsRedactorError.self) {
            try await intent.perform()
        }

        guard case .unpurchased = error else {
            Issue.record("Expected unpurchased error"); return
        }
    }

    @available(iOS 18, *) @MainActor
    @Test func openDocumentScannerIfPurchased() async throws {
        final class SpyNavigator: Navigator {
            private let routeMutex = Mutex<Route?>(nil)
            public var route: Route? {
                get {
                    return routeMutex.withLock { $0 }
                }
                set {
                    routeMutex.withLock { $0 = newValue }
                }
            }
            func navigate(to route: Route) {
                self.route = route
            }
        }

        let navigator = SpyNavigator()
        let manager = AppDependencyManager()
        manager.add(dependency: (navigator as any Navigator))

        let repository = SpyRepository(noOnions: .purchased)
        let intent = OpenDocumentScannerIntent(
            navigator: navigator,
            purchaseRepository: repository
        )

        _ = try await intent.perform()

        guard case .documentScanner = navigator.route else {
            Issue.record("Expected document scanner route"); return
        }
    }
}
