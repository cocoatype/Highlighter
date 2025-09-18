//  Created by Geoff Pado on 2/25/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Testing
import UIKit

@testable import EditingToolbar

@MainActor
struct DebugPreferencesBarButtonItemTests {
    @Test
    func initSetsExpectedValues() {
        class StubTarget {}
        let target = StubTarget()
        let item = DebugPreferencesBarButtonItem(target: target)

        #expect(item.image == UIImage(systemName: "ladybug"))
        #expect(item.style == .plain)
        #expect(item.target === target)
        #expect(item.action == #selector(ActionsBuilderActions.showDebugPreferences(_:)))
        #expect(item.accessibilityLabel == EditingToolbar.Strings.DebugPreferencesBarButtonItem.accessibilityLabel)
    }
}
