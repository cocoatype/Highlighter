//  Created by Geoff Pado on 7/29/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Editing
import XCTest

@testable import Highlighter

class AppRatingsPrompterTests: XCTestCase {
    func testDisplayingPromptOnFirstAttemptDoesNotPrompt() throws {
        Defaults.numberOfSaves = 1
        let promptExpectation = expectation(description: "prompted")
        promptExpectation.isInverted = true
        let prompter = AppRatingsPrompter { _ in
            promptExpectation.fulfill()
        }

        let windowScene = try InstanceHelper.create(UIWindowScene.self)
        prompter.displayRatingsPrompt(in: windowScene)

        waitForExpectations(timeout: 0.01)
    }

    func testDisplayingPromptOnThirdAttemptPrompts() throws {
        Defaults.numberOfSaves = 3
        let promptExpectation = expectation(description: "prompted")
        let prompter = AppRatingsPrompter { _ in
            promptExpectation.fulfill()
        }

        let windowScene = try InstanceHelper.create(UIWindowScene.self)
        prompter.displayRatingsPrompt(in: windowScene)

        waitForExpectations(timeout: 1)
    }

    func testDisplayingPromptOnFifthAttemptPrompts() throws {
        Defaults.numberOfSaves = 5
        let promptExpectation = expectation(description: "prompted")
        let prompter = AppRatingsPrompter { _ in
            promptExpectation.fulfill()
        }

        let windowScene = try InstanceHelper.create(UIWindowScene.self)
        prompter.displayRatingsPrompt(in: windowScene)

        waitForExpectations(timeout: 1)
    }
}
