//  Created by Geoff Pado on 8/14/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import StoreKit

struct PurchaseSection: SettingsContentSection {
    let product: SKProduct?
    let header: String? = nil
    var items: [SettingsContentItem] {[
        PurchaseItem(product: product)
    ]}

    init(product: SKProduct? = nil) {
        self.product = product
    }
}
