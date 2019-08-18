//  Created by Geoff Pado on 8/12/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

struct SettingsSection: SettingsContentSection {
    var header: String? { return nil }

    let items: [SettingsContentItem] = [
        AutoRedactionsItem()
    ]
}
