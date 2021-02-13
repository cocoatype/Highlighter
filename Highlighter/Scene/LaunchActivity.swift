//  Created by Geoff Pado on 2/13/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Foundation

#if targetEnvironment(macCatalyst)
class LaunchActivity: NSUserActivity {
    init(_ fileURL: URL) {
        super.init(activityType: Self.activityType)
        userInfo = [Self.launchActivityURLKey: fileURL.absoluteString]
    }

    // MARK: Boilerplate

    static let activityType = "com.cocoatype.Highlighter.desktop"
    static let launchActivityURLKey = "DesktopSceneDelegate.launchActivityURLKey"

}
#endif
