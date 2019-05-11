//  Created by Geoff Pado on 4/27/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate {
    init() {
        super.init(nibName: nil, bundle: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(AppViewController.dismissSettingsViewController))
    }

    override func loadView() {
        let tableView = SettingsTableView()
        tableView.dataSource = dataSource
        tableView.delegate = self
        view = tableView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let tableView = (view as? SettingsTableView),
          let selectedRowIndex = tableView.indexPathForSelectedRow
        else { return }

        tableView.deselectRow(at: selectedRowIndex, animated: true)
    }

    // MARK: Table View Delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = contentProvider.item(at: indexPath)

        switch item {
        case .about:
            UIApplication.shared.sendAction(#selector(SettingsNavigationController.presentAboutViewController), to: nil, from: self, for: nil)
        case .acknowledgements: break // display acknowledgements
        case .contact: break // display contact e-mail editor
        case .otherApp: break // open App Store
        case .privacy:
            UIApplication.shared.sendAction(#selector(SettingsNavigationController.presentPrivacyViewController), to: nil, from: self, for: nil)
        }
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
