//  Created by Geoff Pado on 8/14/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation

struct PurchaseItem: SettingsContentItem {
    let cellIdentifier = SettingsPurchaseTableViewCell.identifier
    let title = NSLocalizedString("PurchaseItem.title", comment: "Title for the purchase settings content item")
    var subtitle: String { return PurchaseItem.subtitleWithoutProduct }

    func performSelectedAction(_ sender: Any) {}

    private static let subtitleWithoutProduct = NSLocalizedString("PurchaseItem.subtitleWithoutProduct", comment: "Subtitle for the purchase settings content item without space for the product price")
    private static let subtitleWithProduct = NSLocalizedString("PurchaseItem.subtitleWithProduct", comment: "Subtitle for the purchase settings content item with space for the product price")
}
