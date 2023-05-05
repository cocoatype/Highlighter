//  Created by Geoff Pado on 8/26/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class AutoRedactionsListViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        let editView = AutoRedactionsListView()
        editView.dataSource = dataSource
        editView.delegate = dataSource
        view = editView
    }

    func reloadListView() {
        editView?.reloadData()
    }

    // MARK: Boilerplate

    private let dataSource = AutoRedactionsDataSource()
    private var editView: AutoRedactionsListView? { return view as? AutoRedactionsListView }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
