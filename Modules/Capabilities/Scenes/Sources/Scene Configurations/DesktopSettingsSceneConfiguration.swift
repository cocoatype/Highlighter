//  Created by Geoff Pado on 7/26/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import UIKit

#if targetEnvironment(macCatalyst)
class DesktopSettingsSceneConfiguration: WindowSceneConfiguration {
    init() {
        super.init(name: "Settings")
    }
}
#endif
