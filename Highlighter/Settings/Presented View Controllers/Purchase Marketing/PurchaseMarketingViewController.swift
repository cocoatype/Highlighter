//  Created by Geoff Pado on 8/14/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PurchaseMarketingViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)

        navigationItem.rightBarButtonItem = restoreButton
        navigationItem.title = PurchaseMarketingViewController.navigationTitle
    }

    override func loadView() {
        super.loadView()
        view = PurchaseMarketingView()
    }

    // MARK: Restore

    private let restoreButton = UIBarButtonItem(title: PurchaseMarketingViewController.restoreButtonTitle, style: .plain, target: nil, action: nil)

    // MARK: Boilerplate

    private static let navigationTitle = NSLocalizedString("PurchaseMarketingViewController.navigationTitle", comment: "Navigation title for the purchase marketing view")
    private static let restoreButtonTitle = NSLocalizedString("PurchaseMarketingViewController.restoreButtonTitle", comment: "Restore button title for the purchase marketing view")

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
