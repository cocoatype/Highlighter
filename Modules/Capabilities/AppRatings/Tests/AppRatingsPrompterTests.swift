//  Created by Geoff Pado on 7/29/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Testing
import UIKit

import FactoryKit
import FactoryTesting

import Defaults
import DefaultsDoubles
import Editing
import LoggingDoubles
import TestHelpers

@testable import AppRatings
@testable import Logging

@MainActor @Suite(.container)
struct AppRatingsPrompterTests {
    @Test(arguments: [
        (1, false),
        (3, true),
        (5, false),
        (6, true),
    ])
    func displayRatingsPrompt(numberOfSaves: Int, shouldDisplay: Bool) async throws {
        Container.shared.defaults.register { @MainActor in
            StubDefaultsProvider(numberOfSaves: numberOfSaves)
        }
        Container.shared.logger.register { SpyLogger() }
        let expectedCount = shouldDisplay ? 1 : 0
        try await confirmation(expectedCount: expectedCount) { confirmation in
            let prompter = AppRatingsPrompter { _ in
                confirmation.confirm()
            }

            let windowScene = try InstanceHelper.create(UIWindowScene.self)
            await prompter.displayRatingsPrompt(in: windowScene)
        }
    }

    @Test func displayingPromptWithNoWindowSceneLogsError() async throws {
        Container.shared.defaults.register { @MainActor in
            StubDefaultsProvider(numberOfSaves: 1)
        }
        let spy = SpyLogger()
        Container.shared.logger.register { spy }
        let prompter = AppRatingsPrompter { _ in }

        await prompter.displayRatingsPrompt(in: nil)

        let event = try #require(spy.loggedEvents.first)
        #expect(event.value == "TelemetryDeck.Error.occurred")
        #expect(event.info["TelemetryDeck.Error.id"] == "AppRatingsError.missingWindowScene")
    }

    @Test func displayingPromptLogsEvent() async throws {
        let spy = SpyLogger()
        Container.shared.logger.register { spy }
        Container.shared.defaults.register { @MainActor in
            StubDefaultsProvider(numberOfSaves: 999)
        }
        let prompter = AppRatingsPrompter { _ in }
        let windowScene = try InstanceHelper.create(UIWindowScene.self)

        await prompter.displayRatingsPrompt(in: windowScene)

        let event = try #require(spy.loggedEvents.first)
        #expect(event.value == "AppRatingsPrompter.requestedRating")
    }
}
