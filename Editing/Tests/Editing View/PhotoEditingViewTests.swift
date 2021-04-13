//  Created by Geoff Pado on 4/11/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

@testable import Editing
import XCTest

class PhotoEditingViewTests: XCTestCase {
    func testBackgroundColorOnDesktopLightMode() throws {
        try TestHelpers.runOnMacCatalyst()
        TestHelpers.performInLightMode {
            do {
                let workspaceView = PhotoEditingView()
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
                let workspaceView = PhotoEditingView()
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
                let workspaceView = PhotoEditingView()
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
                let workspaceView = PhotoEditingView()
                let backgroundColor = try XCTUnwrap(workspaceView.backgroundColor?.hexString)
                print(UIColor.secondarySystemBackground.hexString)
                XCTAssertEqual(backgroundColor, "#212121")
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }
}
