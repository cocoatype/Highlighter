//  Created by Geoff Pado on 8/3/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import DesignSystem
import UIKit

class AutoRedactionsListView: UITableView {
    init() {
        super.init(frame: .zero, style: .insetGrouped)
        backgroundColor = .primary
        indicatorStyle = .white
        separatorColor = UIColor.Borders.standard

        register(AutoRedactionsTableViewCell.self, forCellReuseIdentifier: AutoRedactionsTableViewCell.identifier)
        register(AutoRedactionsEntryTableViewCell.self, forCellReuseIdentifier: AutoRedactionsEntryTableViewCell.ohSheet)
        register(AutoRedactionsCategoryTableViewCell.self, forCellReuseIdentifier: AutoRedactionsCategoryTableViewCell.anInconvenientVariableName)
    }

    func handleDeletion() {
        UIApplication.shared.sendAction(#selector(AutoRedactionsListViewController.reloadRedactionsView), to: nil, from: self, for: nil)
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
