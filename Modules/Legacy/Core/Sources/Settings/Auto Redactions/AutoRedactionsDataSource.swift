//  Created by Geoff Pado on 8/3/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Defaults
import Editing
import ErrorHandling
import UIKit

class AutoRedactionsDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let redactionCell = tableView.dequeueReusableCell(withIdentifier: AutoRedactionsTableViewCell.identifier, for: indexPath) as? AutoRedactionsTableViewCell else { ErrorHandler().crash("Auto redactions table view cell is not a AutoRedactionsTableViewCell") }

        redactionCell.word = wordList[indexPath.row]

        return redactionCell
    }

    private var wordList: [String] { return Defaults.autoRedactionsWordList }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: AutoRedactionsDataSource.deleteActionTitle) { [weak self] _, _, handler in
            guard var newWordList = self?.wordList else {
                handler(false)
                return
            }

            newWordList.remove(at: indexPath.row)
            Defaults.autoRedactionsWordList = newWordList

            tableView.deleteRows(at: [indexPath], with: .automatic)

            (tableView as? AutoRedactionsListView)?.handleDeletion()

            handler(true)
        }

        return UISwipeActionsConfiguration(actions: [action])
    }

    // MARK: Localized Strings

    private static let deleteActionTitle = NSLocalizedString("AutoRedactionsDataSource.deleteActionTitle", comment: "Title for the delete action on the auto redactions word list")
}
