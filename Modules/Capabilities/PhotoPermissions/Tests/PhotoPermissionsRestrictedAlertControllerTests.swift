//  Created by Geoff Pado on 3/3/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Testing

@testable import PhotoPermissions

@MainActor
struct PhotoPermissionsRestrictedAlertControllerTests {
    @Test
    func alertHasOnlyDismissAction() throws {
        let factory = PhotoPermissionsRestrictedAlertFactory()
        let alert = factory.alert()
        #expect(alert.actions.count == 1)
        let action = try #require(alert.actions.last as? PhotoPermissionsAlertAction)
        #expect(action.handler == nil)
    }
}
