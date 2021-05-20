//  Created by Geoff Pado on 8/14/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import StoreKit
import UIKit

class PurchaseMarketingViewController: UIViewController {
    init(product: SKProduct? = nil) {
        self.product = product
        super.init(nibName: nil, bundle: nil)

        navigationItem.rightBarButtonItem = restoreButton
        navigationItem.title = PurchaseMarketingViewController.navigationTitle
    }

    override func loadView() {
        super.loadView()
        view = LegacyPurchaseMarketingView(product: product)
    }

    // MARK: Restore

    private let restoreButton = UIBarButtonItem(title: PurchaseMarketingViewController.restoreButtonTitle, style: .plain, target: nil, action: #selector(SettingsNavigationController.startRestore))

    // MARK: Boilerplate

    private static let navigationTitle = NSLocalizedString("PurchaseMarketingViewController.navigationTitle", comment: "Navigation title for the purchase marketing view")
    private static let restoreButtonTitle = NSLocalizedString("PurchaseMarketingViewController.restoreButtonTitle", comment: "Restore button title for the purchase marketing view")

    private let product: SKProduct?

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
