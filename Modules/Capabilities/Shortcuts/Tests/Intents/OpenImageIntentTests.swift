//  Created by Geoff Pado on 7/16/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import AppIntents
import Testing
import UIKit

import FactoryKit

import AppNavigation
import AppNavigationDoubles
import LoggingDoubles
import PurchasingDoubles

@testable import Logging
@testable import Shortcuts

@Suite(.container)
struct OpenImageIntentTests {
    @available(iOS 16, *)
    @Test func throwsErrorIfUnpurchased() async throws {
        Container.shared.purchaseRepository.register {
            SpyRepository(noOnions: .unavailable)
        }

        let error = try await #require(throws: ShortcutsRedactorError.self) {
            try await OpenImageIntent().perform()
        }

        #expect(error.isUnpurchased == true)
    }
    @available(iOS 16, *)
    @Test func throwsErrorIfMissingImage() async throws {
        Container.shared.purchaseRepository.register {
            SpyRepository(noOnions: .purchased)
        }

        let error = try await #require(throws: ShortcutsRedactorError.self) {
            try await OpenImageIntent(
                sourceImage: IntentFile(data: Data(), filename: "sample"),
                redactions: []
            ).perform()
        }

        #expect(error.isNoImage == true)
    }

    #if !targetEnvironment(macCatalyst)
    @available(iOS 18, *) @MainActor
    @Test func opensImage() async throws {
        let navigator = SpyNavigator()

        Container.shared.purchaseRepository.register {
            SpyRepository(noOnions: .purchased)
        }

        let sampleImageData = try #require(UIImage(systemName: "bolt")?.pngData())

        _ = try await OpenImageIntent(
            sourceImage: IntentFile(data: sampleImageData, filename: "sample"),
            redactions: [],
            navigator: navigator
        ).perform()

        #expect(navigator.route?.isEditor == true)
    }
    #endif

    @available(iOS 18, *) @MainActor
    @Test func logsUsageEvent() async throws {
        let logger = SpyLogger()
        Container.shared.logger.register { logger }
        Container.shared.purchaseRepository.register {
            SpyRepository(noOnions: .purchased)
        }

        let sampleImageData = try #require(UIImage(systemName: "bolt")?.pngData())

        _ = try await OpenImageIntent(
            sourceImage: IntentFile(data: sampleImageData, filename: "sample"),
            redactions: [],
            navigator: SpyNavigator()
        ).perform()

        let event = try #require(logger.loggedEvents.first { loggedEvent in
            loggedEvent.name == "Shortcuts.intentUsed"
        })
        #expect(event.info["usage"] == "openImage")
    }
}
