//  Created by Geoff Pado on 4/27/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class SettingsTableViewDataSource: NSObject, UITableViewDataSource {
    init(contentProvider: SettingsContentProvider) {
        self.contentProvider = contentProvider
        super.init()
    }

    // MARK: UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return contentProvider.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentProvider.numberOfItems(inSectionAtIndex: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = contentProvider.item(at: indexPath)

        switch item {
        case .otherApp(let appEntry):
            return appEntryCell(for: appEntry, at: indexPath, in: tableView)
        default:
            return itemCell(for: item, at: indexPath, in: tableView)
        }
    }

    private func appEntryCell(for appEntry: AppEntry, at indexPath: IndexPath, in tableView: UITableView) -> SettingsAppEntryTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsAppEntryTableViewCell.identifier, for: indexPath)
        guard let appEntryCell = (cell as? SettingsAppEntryTableViewCell) else { fatalError("Settings table view cell is not a SettingsAppEntryTableViewCell") }

        appEntryCell.appEntry = appEntry
        return appEntryCell
    }

    private func itemCell(for item: SettingsContentProvider.Item, at indexPath: IndexPath, in tableView: UITableView) -> SettingsTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath)
        guard let settingsCell = (cell as? SettingsTableViewCell) else { fatalError("Settings table view cell is not a SettingsTableViewCell") }

        settingsCell.item = item

        return settingsCell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contentProvider.section(at: section).header
    }

    // MARK: Boilerplate

    private var contentProvider: SettingsContentProvider
}
