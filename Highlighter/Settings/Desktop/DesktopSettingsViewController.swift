//  Created by Geoff Pado on 9/28/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import SwiftUI
import UIKit

class DesktopSettingsViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)

        embed(preferredViewController)

        purchaserObservation = NotificationCenter.default.addObserver(forName: Purchaser.stateDidChange, object: nil, queue: .main, using: { [weak self] _ in
            self?.purchaseStateDidChange()
        })
    }

    deinit {
        purchaserObservation.map(NotificationCenter.default.removeObserver)
    }

    private var preferredViewController: UIViewController {
        switch purchaser.state {
        case .purchased: return DesktopAutoRedactionsListViewController()
        default: return UIHostingController(rootView: PurchaseMarketingView())
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
        embed(preferredViewController)
    }

    // MARK: Boilerplate

    private let purchaser = Purchaser()
    private var purchaserObservation: Any?

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
