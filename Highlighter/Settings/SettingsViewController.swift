//  Created by Geoff Pado on 4/27/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate {
    init() {
        super.init(nibName: nil, bundle: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(AppViewController.dismissSettingsViewController))
        navigationItem.title = SettingsViewController.navigationTitle

        activeObserver = NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { [weak self] _ in
            self?.deselectSelectedRows()
        }
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
        deselectSelectedRows()
    }

    // MARK: User Interface

    private func deselectSelectedRows() {
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
                guard let otherAppsSectionIndex = contentProvider.sectionIndex(for: OtherAppsSection.self) else { return }
                self?.tableView?.reloadSections(IndexSet(integer: otherAppsSectionIndex), with: .automatic)
            }
        }
    }

    // MARK: Table View Delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = contentProvider.item(at: indexPath)

        switch item {
        case is AboutItem:
            sendResponderAction(#selector(SettingsNavigationController.presentAboutViewController))
        case is AcknowledgementsItem:
            sendResponderAction(#selector(SettingsNavigationController.presentAcknowledgementsViewController))
        case is AutoRedactionsItem:
        sendResponderAction(#selector(SettingsNavigationController.presentAutoRedactionsEditViewController))
        case is ContactItem:
            sendResponderAction(#selector(SettingsNavigationController.presentContactViewController))
        case let appItem as OtherAppItem:
            appEntryOpener?.openAppStore(displaying: appItem.appEntry)
        case is PrivacyItem:
            sendResponderAction(#selector(SettingsNavigationController.presentPrivacyViewController))
        default: break
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SettingsTableViewHeaderFooterView.identifier) as? SettingsTableViewHeaderFooterView else { fatalError("Got incorrect header view type") }
        headerView.text = contentProvider.section(at: section).header
        return headerView
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return SettingsTableViewHeaderFooterLabel().font.lineHeight
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    private func sendResponderAction(_ selector: Selector) {
        UIApplication.shared.sendAction(selector, to: nil, from: self, for: nil)
    }

    // MARK: Boilerplate

    private static let navigationTitle = NSLocalizedString("SettingsViewController.navigationTitle", comment: "Navigation title for the settings view controller")

    private var activeObserver: Any?
    private let contentProvider = SettingsContentProvider()
    private lazy var dataSource = SettingsTableViewDataSource(contentProvider: contentProvider)
    private var tableView: SettingsTableView? { return view as? SettingsTableView }

    deinit {
        activeObserver.map(NotificationCenter.default.removeObserver)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
