//  Created by Geoff Pado on 6/29/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Purchasing
import ViewInspector
import XCTest

@testable import SettingsUI

class SettingsContentTests: XCTestCase {
    func testSettingsContentContainsAppropriateSections() throws {
        let content = try SettingsContent(state: .constant(.loading)).inspect().find(SettingsContent.self).implicitAnyView()

        try XCTAssertNoThrow(content.view(SettingsContentPurchasedFeaturesSection.self, 0), "Did not find purchased features section")
        try XCTAssertNoThrow(content.view(SettingsContentInformationSection.self, 1), "Did not find information section")
        try XCTAssertNoThrow(content.view(SettingsContentContactSection.self, 2), "Did not find contact section")
        try XCTAssertNoThrow(content.view(SettingsContentOtherAppsSection.self, 3), "Did not find other apps section")
    }
}
