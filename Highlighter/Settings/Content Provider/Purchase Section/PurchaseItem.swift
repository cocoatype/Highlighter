//  Created by Geoff Pado on 8/14/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import StoreKit
import UIKit

struct PurchaseItem: SettingsContentItem {
    let cellIdentifier = SettingsPurchaseTableViewCell.identifier
    let title = NSLocalizedString("PurchaseItem.title", comment: "Title for the purchase settings content item")
    let product: SKProduct?

    var subtitle: String {
        guard let price = localizedProductPrice else { return PurchaseItem.subtitleWithoutProduct }

        return String(format: PurchaseItem.subtitleWithProduct, price)
    }

    func performSelectedAction(_ sender: Any) {
        UIApplication.shared.sendAction(#selector(SettingsNavigationController.presentPurchaseMarketingViewController), to: nil, from: sender, for: nil)
    }

    // MARK: Price Formatting

    private static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        return formatter
    }()

    private var localizedProductPrice: String? {
        guard let product = product else { return nil }

        if product.priceLocale != Self.priceFormatter.locale {
            Self.priceFormatter.locale = product.priceLocale
        }

        return Self.priceFormatter.string(from: product.price)
    }

    // MARK: Localized Strings

    private static let subtitleWithoutProduct = NSLocalizedString("PurchaseItem.subtitleWithoutProduct", comment: "Subtitle for the purchase settings content item without space for the product price")
    private static let subtitleWithProduct = NSLocalizedString("PurchaseItem.subtitleWithProduct", comment: "Subtitle for the purchase settings content item with space for the product price")
}
