//  Created by Geoff Pado on 5/16/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import ErrorHandling
import Foundation
import Sentry

struct DebugSection: SettingsContentSection {
    var header: String? { return nil }
    let items: [SettingsContentItem] = [
        CrashItem()
    ]
}

struct CrashItem: StandardContentItem {
    let title = "Crash"

    func performSelectedAction(_ sender: Any) {
        ErrorHandling.crash("Debug Crash")
    }
}
