//  Created by Geoff Pado on 5/11/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import UIKit

class SettingsNavigationController: NavigationController {
    init() {
        let settingsViewController = SettingsViewController(purchaser: purchaser)
        super.init(rootViewController: settingsViewController)
        modalPresentationStyle = .formSheet
        purchaserObservation = NotificationCenter.default.addObserver(forName: Purchaser.stateDidChange, object: nil, queue: .main, using: { [weak self] _ in
            guard let purchaser = self?.purchaser else { return }
            if case .purchased = purchaser.state {
                self?.purchaseDidSucceed()
            }

            self?.purchaseStateDidChange()
        })
    }

    // MARK: Navigation

    @objc func presentAboutViewController() {
        guard let aboutViewController = AboutViewController() else { return }
        present(aboutViewController, animated: true)
    }

    @objc func presentAcknowledgementsViewController() {
        guard let acknowledgementsViewController = AcknowledgementsViewController() else { return }
        present(acknowledgementsViewController, animated: true)
    }

    @objc func presentAutoRedactionsEditViewController() {
        pushViewController(AutoRedactionsEditViewController(), animated: true)
    }

    @objc func presentContactViewController() {
        if ContactMailViewController.canBePresented {
            let contactViewController = ContactMailViewController()
            present(contactViewController, animated: true)
        } else {
            guard let contactViewController = ContactWebViewController() else { return }
            present(contactViewController, animated: true)
        }
    }

    @objc func dismissContactMailViewController() {
        if presentedViewController is ContactMailViewController {
            dismiss(animated: true)
        }
    }

    @objc func presentPrivacyViewController() {
        guard let privacyViewController = PrivacyViewController() else { return }
        present(privacyViewController, animated: true)
    }

    @objc func presentPurchaseMarketingViewController() {
        if case let PurchaseState.readyForPurchase(product: product) = purchaser.state {
            pushViewController(PurchaseMarketingViewController(product: product), animated: true)
        } else {
            pushViewController(PurchaseMarketingViewController(product: nil), animated: true)
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
        settingsViewController?.refreshPurchaseSection()
    }

    private func purchaseDidSucceed() {
        popToRootViewController(animated: true)
    }

    // MARK: Boilerplate

    private let purchaser = Purchaser()
    private var purchaserObservation: Any?
    private var settingsViewController: SettingsViewController? { return viewControllers.first as? SettingsViewController }

    deinit {
        purchaserObservation.map(NotificationCenter.default.removeObserver)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
