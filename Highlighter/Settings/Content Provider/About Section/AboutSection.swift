//  Created by Geoff Pado on 8/12/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

struct AboutSection: SettingsContentSection {
    var header: String? { return nil }
    var items: [SettingsContentItem] {
        return [
            AboutItem(),
            PrivacyItem(),
            AcknowledgementsItem(),
            ContactItem()
        ]
    }
}
