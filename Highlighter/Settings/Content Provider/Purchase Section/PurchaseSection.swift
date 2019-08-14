//  Created by Geoff Pado on 8/14/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

struct PurchaseSection: SettingsContentSection {
    let header: String? = nil
    let items: [SettingsContentItem] = [
        PurchaseItem()
    ]
}
