//  Created by Geoff Pado on 3/3/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Testing
import UIKit

@testable import PhotoPermissions

@MainActor
struct PhotoPermissionsDeniedAlertControllerTests {
    @Test
    func alertHasTwoActions() {
        let factory = PhotoPermissionsDeniedAlertFactory()
        let alert = factory.alert()
        #expect(alert.actions.count == 2)
    }

    @Test
    func alertHasSettingsAction() async throws {
        struct URLOpener: URLOpening {
            let urlOpened: Confirmation
            func open(
                _ url: URL,
                options: [UIApplication.OpenExternalURLOptionsKey: Any],
                completionHandler completion: (@MainActor @Sendable (Bool) -> Void)?
            ) { urlOpened() }
        }
        try await confirmation { urlOpened in
            let opener = URLOpener(urlOpened: urlOpened)
            let factory = PhotoPermissionsDeniedAlertFactory(urlOpener: opener)
            let alert = factory.alert()
            let action = try #require(alert.actions.first as? PhotoPermissionsAlertAction)
            action.handler?(action)
        }
    }

    @Test
    func alertHasCancelAction() throws {
        let factory = PhotoPermissionsDeniedAlertFactory()
        let alert = factory.alert()
        let action = try #require(alert.actions.last as? PhotoPermissionsAlertAction)
        #expect(action.handler == nil)
    }
}
