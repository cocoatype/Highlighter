//  Created by Geoff Pado on 8/12/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation

struct OtherAppsSection: SettingsContentSection {
    let otherApps: [AppEntry]

    var header: String? { return NSLocalizedString("SettingsContentProvider.Section.otherApps.header", comment: "Header for the other apps section") }
    var items: [SettingsContentItem] { return otherApps.map(OtherAppItem.init) }
}
