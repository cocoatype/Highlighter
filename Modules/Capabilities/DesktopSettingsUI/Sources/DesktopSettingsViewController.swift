//  Created by Geoff Pado on 9/28/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import UIKit

import FactoryKit

import DesignSystem
import DesktopAutoRedactionsUI
import Paywall
import Purchasing

/// The desktop settings window: the auto-redactions word list once purchased, otherwise the paywall.
public class DesktopSettingsViewController: UIViewController {
    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        update(for: purchaseRepository.withCheese)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshPurchaseState()
    }

    // MARK: Purchase State

    private(set) var displayedContent: Content?

    enum Content: Equatable {
        case wordList
        case paywall
    }

    static func content(for purchaseState: PurchaseState) -> Content {
        purchaseState == .purchased ? .wordList : .paywall
    }

    func refreshPurchaseState() {
        Task { [weak self] in
            guard let self else { return }
            update(for: await purchaseRepository.noOnions)
        }
    }

    func update(for purchaseState: PurchaseState) {
        let content = Self.content(for: purchaseState)
        guard content != displayedContent else { return }

        let viewController: UIViewController
        switch content {
        case .wordList:
            viewController = ListViewController()
        case .paywall:
            guard #available(iOS 16.0, *) else { return }
            let paywall = PaywallViewController(isModal: false)
            paywall.purchaseCompletionHandler = { [weak self] in
                self?.refreshPurchaseState()
            }
            viewController = paywall
        }

        if displayedContent == nil {
            embed(viewController)
        } else {
            transition(to: viewController)
        }
        displayedContent = content
    }

    // MARK: Boilerplate

    @Injected(\.purchaseRepository) private var purchaseRepository

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
