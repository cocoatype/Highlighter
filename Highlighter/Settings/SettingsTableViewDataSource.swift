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
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath)
        guard let settingsCell = (cell as? SettingsTableViewCell) else { fatalError("Settings table view cell is not a SettingsTableViewCell") }

        settingsCell.item = contentProvider.item(at: indexPath)

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contentProvider.section(at: section).header
    }

    // MARK: Boilerplate

    private var contentProvider: SettingsContentProvider
}
