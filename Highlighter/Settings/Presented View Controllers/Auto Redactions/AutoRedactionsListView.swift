//  Created by Geoff Pado on 8/3/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class AutoRedactionsListView: UITableView {
    init() {
        super.init(frame: .zero, style: .grouped)
        backgroundColor = .primary
        separatorColor = .primaryExtraLight
        separatorInset = .zero
        indicatorStyle = .white

        register(AutoRedactionsTableViewCell.self, forCellReuseIdentifier: AutoRedactionsTableViewCell.identifier)
    }

    func handleDeletion() {
        UIApplication.shared.sendAction(#selector(AutoRedactionsEditViewController.reloadRedactionsView), to: nil, from: self, for: nil)
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
