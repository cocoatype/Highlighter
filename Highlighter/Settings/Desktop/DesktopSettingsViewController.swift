//  Created by Geoff Pado on 9/28/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import UIKit

class DesktopSettingsViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)

        embed(preferredViewController)
    }

    private var preferredViewController: UIViewController {
        switch purchaser.state {
        case .purchased: return DesktopAutoRedactionsListViewController()
        case .readyForPurchase(let product): return PurchaseMarketingViewController(product: product)
        default: return PurchaseMarketingViewController()
        }
    }

    // MARK: Purchasing

    @objc func startPurchase() {
        purchaser.purchaseUnlock()
    }

    @objc func startRestore() {
        purchaser.restorePurchases()
    }

    private func purchaseStateDidChange() {
//        settingsViewController?.refreshPurchaseSection()
    }

    private func purchaseDidSucceed() {
//        popToRootViewController(animated: true)
    }

    // MARK: Boilerplate

    private let purchaser = Purchaser()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
