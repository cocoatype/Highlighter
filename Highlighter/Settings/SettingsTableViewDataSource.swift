//  Created by Geoff Pado on 4/27/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class SettingsTableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as? SettingsContentTableViewCell else {
            fatalError("Settings table view cell is not a SettingsContentTableViewCell: \(item.cellIdentifier)")
        }

        cell.item = item
        return cell
    }

    // MARK: Table View Delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contentProvider.item(at: indexPath).performSelectedAction(tableView)
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

    // MARK: Boilerplate

    private var contentProvider: SettingsContentProvider
}
