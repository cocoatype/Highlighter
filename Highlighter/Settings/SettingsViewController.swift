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
        refreshOtherAppsList()

        guard let tableView = tableView,
          let selectedRowIndex = tableView.indexPathForSelectedRow
        else { return }

        tableView.deselectRow(at: selectedRowIndex, animated: true)
    }

    // MARK: Other Apps

    private func refreshOtherAppsList() {
        AppListFetcher().fetchAppEntries { [weak self] appEntries, _ in
            guard let appEntries = appEntries,
              let contentProvider = self?.contentProvider
            else { return }

            contentProvider.otherAppEntries = appEntries

            DispatchQueue.main.async { [weak self] in
                self?.tableView?.reloadSections(IndexSet(integer: 1), with: .automatic)
            }
        }
    }

    // MARK: Table View Delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = contentProvider.item(at: indexPath)

        switch item {
        case .about:
            sendResponderAction(#selector(SettingsNavigationController.presentAboutViewController))
        case .acknowledgements:
            sendResponderAction(#selector(SettingsNavigationController.presentAcknowledgementsViewController))
        case .contact:
            sendResponderAction(#selector(SettingsNavigationController.presentContactViewController))
        case .otherApp: break // open App Store
        case .privacy:
            sendResponderAction(#selector(SettingsNavigationController.presentPrivacyViewController))
        }
    }

    private func sendResponderAction(_ selector: Selector) {
        UIApplication.shared.sendAction(selector, to: nil, from: self, for: nil)
    }

    // MARK: Boilerplate

    private let contentProvider = SettingsContentProvider()
    private lazy var dataSource = SettingsTableViewDataSource(contentProvider: contentProvider)
    private var tableView: SettingsTableView? { return view as? SettingsTableView }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
