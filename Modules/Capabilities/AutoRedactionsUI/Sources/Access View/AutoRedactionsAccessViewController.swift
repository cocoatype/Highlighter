//  Created by Geoff Pado on 4/26/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import UIKit

public class AutoRedactionsAccessViewController: UIViewController {
    public init() {
        super.init(nibName: nil, bundle: nil)

        navigationItem.title = Self.navigationTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: nil,
            action: #selector(AutoRedactionsAccessActions.hideAutoRedactAccess(_:))
        )

        embed(AutoRedactionsListViewController())
    }

    // MARK: Boilerplate

    private static let navigationTitle = Strings.AutoRedactionsAccessViewController.navigationTitle

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
