//  Created by Geoff Pado on 7/29/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Defaults
import Editing
import TestHelpers
import XCTest

@testable import AppRatings
@testable import Logging

class AppRatingsPrompterTests: XCTestCase {
    func testDisplayingPromptOnFirstAttemptDoesNotPrompt() throws {
        Defaults.numberOfSaves = 1
        let promptExpectation = expectation(description: "prompted")
        promptExpectation.isInverted = true
        let prompter = AppRatingsPrompter(logger: SpyLogger()) { _ in
            promptExpectation.fulfill()
        }

        let windowScene = try InstanceHelper.create(UIWindowScene.self)
        prompter.displayRatingsPrompt(in: windowScene)

        waitForExpectations(timeout: 0.01)
    }

    func testDisplayingPromptOnThirdAttemptPrompts() throws {
        Defaults.numberOfSaves = 3
        let promptExpectation = expectation(description: "prompted")
        let prompter = AppRatingsPrompter(logger: SpyLogger()) { _ in
            promptExpectation.fulfill()
        }

        let windowScene = try InstanceHelper.create(UIWindowScene.self)
        prompter.displayRatingsPrompt(in: windowScene)

        waitForExpectations(timeout: 1)
    }

    func testDisplayingPromptOnFifthAttemptPrompts() throws {
        Defaults.numberOfSaves = 5
        let promptExpectation = expectation(description: "prompted")
        let prompter = AppRatingsPrompter(logger: SpyLogger()) { _ in
            promptExpectation.fulfill()
        }

        let windowScene = try InstanceHelper.create(UIWindowScene.self)
        prompter.displayRatingsPrompt(in: windowScene)

        waitForExpectations(timeout: 1)
    }

    func testDisplayingPromptWithNoWindowSceneLogsError() throws {
        let spy = SpyLogger()
        let prompter = AppRatingsPrompter(logger: spy) { _ in }

        prompter.displayRatingsPrompt(in: nil)

        let event = try XCTUnwrap(spy.loggedEvent)
        XCTAssertEqual(event.value, "logError")
        XCTAssertEqual(event.info, ["errorDescription": "missingWindowScene"])
    }

    func testDisplayingPromptLogsEvent() throws {
        Defaults.numberOfSaves = 999
        let spy = SpyLogger()
        let prompter = AppRatingsPrompter(logger: spy) { _ in }
        let windowScene = try InstanceHelper.create(UIWindowScene.self)

        prompter.displayRatingsPrompt(in: windowScene)

        let event = try XCTUnwrap(spy.loggedEvent)
        XCTAssertEqual(event.value, "AppRatingsPrompter.requestedRating")
    }
}

private class SpyLogger: Logger {
    private(set) var loggedEvent: Event?
    func log(_ event: Event) {
        loggedEvent = event
    }
}
