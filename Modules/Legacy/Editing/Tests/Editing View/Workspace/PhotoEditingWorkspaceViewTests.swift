//  Created by Geoff Pado on 4/11/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import XCTest

import FactoryKit
import FactoryTesting

import LoggingDoubles

@testable import Editing
@testable import Logging

class PhotoEditingWorkspaceViewTests: XCTestCase {
    func testBackgroundColorOnDesktopLightMode() throws {
        try TestHelpers.runOnMacCatalyst()
        TestHelpers.performInLightMode {
            do {
                let workspaceView = PhotoEditingWorkspaceView()
                let backgroundColor = try XCTUnwrap(workspaceView.backgroundColor?.hexString)
                print(UIColor.secondarySystemBackground.hexString)
                XCTAssertEqual(backgroundColor, "#ececec")
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }

    func testBackgroundColorOnDesktopDarkMode() throws {
        try TestHelpers.runOnMacCatalyst()
        TestHelpers.performInDarkMode {
            do {
                let workspaceView = PhotoEditingWorkspaceView()
                let backgroundColor = try XCTUnwrap(workspaceView.backgroundColor?.hexString)
                print(UIColor.secondarySystemBackground.hexString)
                XCTAssertEqual(backgroundColor, "#323232")
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }

    func testBackgroundColorOnMobileLightMode() throws {
        try TestHelpers.skipOnMacCatalyst()
        TestHelpers.performInLightMode {
            do {
                let workspaceView = PhotoEditingWorkspaceView()
                let backgroundColor = try XCTUnwrap(workspaceView.backgroundColor?.hexString)
                print(UIColor.secondarySystemBackground.hexString)
                XCTAssertEqual(backgroundColor, "#212121")
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }

    func testBackgroundColorOnMobileDarkMode() throws {
        try TestHelpers.skipOnMacCatalyst()
        TestHelpers.performInDarkMode {
            do {
                let workspaceView = PhotoEditingWorkspaceView()
                let backgroundColor = try XCTUnwrap(workspaceView.backgroundColor?.hexString)
                print(UIColor.secondarySystemBackground.hexString)
                XCTAssertEqual(backgroundColor, "#212121")
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }

    func testWhenHandleStrokeCompletionThenEventLogged() throws {
        let logger = SpyLogger()
        Container.shared.logger.register { logger }
        defer { Container.shared.reset() }
        let workspaceView = PhotoEditingWorkspaceView()
        workspaceView.handleStrokeCompletion()

        let loggedEvent = try XCTUnwrap(logger.loggedEvents.first)
        XCTAssertEqual(loggedEvent.name, "PhotoEditingWorkspaceView.strokeCompleted")
        XCTAssertEqual(loggedEvent.info["tool"], "magic")
        XCTAssertEqual(loggedEvent.info["color"], "#000000")
    }
}
