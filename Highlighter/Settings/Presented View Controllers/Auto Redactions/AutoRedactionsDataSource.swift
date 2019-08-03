//  Created by Geoff Pado on 8/3/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import UIKit

class AutoRedactionsDataSource: NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let redactionCell = tableView.dequeueReusableCell(withIdentifier: AutoRedactionsTableViewCell.identifier, for: indexPath) as? AutoRedactionsTableViewCell else { fatalError("Auto redactions table view cell is not a AutoRedactionsTableViewCell") }

        redactionCell.word = wordList[indexPath.row]

        return redactionCell
    }

    private var wordList: [String] { return Defaults.autoRedactionsWordList }
}
