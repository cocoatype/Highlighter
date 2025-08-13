//  Created by Geoff Pado on 6/29/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import ViewInspector
import XCTest

@testable import MobileSettingsUI

@MainActor
class SettingsContentInformationSectionTests: XCTestCase {
    func testContainsVersionInformationItem() throws {
        let section = try SettingsContentInformationSection(
            infoDictionary: [
                "CFBundleShortVersionString": "89.0",
            ]
        ).inspect().find(SettingsContentInformationSection.self)

        let button = section.findAll(WebURLButton.self)[0]
        XCTAssertNoThrow(try button.find(text: "Version 89.0"))
    }

    func testVersionInformationFallback() throws {
        let section = try SettingsContentInformationSection(
            infoDictionary: [:]
        ).inspect().find(SettingsContentInformationSection.self)
        let button = section.findAll(WebURLButton.self)[0]
        XCTAssertNoThrow(try button.find(text: "Version ???"))
    }
}
