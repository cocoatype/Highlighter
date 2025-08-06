//  Created by Geoff Pado on 6/29/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Purchasing
import ViewInspector
import Testing

@testable import SettingsUI

@MainActor struct SettingsContentTests {
    @Test func settingsContentContainsAppropriateSections() throws {
        let content = try SettingsContent(state: .loading)
            .inspect()
            .find(SettingsContent.self)

        #expect(throws: Never.self, "Did not find purchased features section") {
            try content.view(SettingsContentPurchasedFeaturesSection.self, 0)
        }
        #expect(throws: Never.self, "Did not find information section") {
            try content.view(SettingsContentInformationSection.self, 1)
        }
        #expect(throws: Never.self, "Did not find contact section") {
            try content.view(SettingsContentContactSection.self, 2)
        }
        #expect(throws: Never.self, "Did not find other apps section") {
            try content.view(SettingsContentOtherAppsSection.self, 3)
        }
    }
}
