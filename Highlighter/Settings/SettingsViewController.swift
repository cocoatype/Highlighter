//  Created by Geoff Pado on 4/27/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class SettingsViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(AppViewController.dismissSettingsViewController))
    }

    override func loadView() {
        let tableView = SettingsTableView()
        tableView.dataSource = dataSource
        view = tableView
    }

    // MARK: Boilerplate
    private let contentProvider = SettingsContentProvider()
    private lazy var dataSource = SettingsTableViewDataSource(contentProvider: contentProvider)

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
