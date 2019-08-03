//  Created by Geoff Pado on 8/3/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class AutoRedactionsEditViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)

        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        navigationItem.rightBarButtonItem = addButtonItem
    }

    override func loadView() {
        let editView = AutoRedactionEditView()
        editView.dataSource = dataSource
        view = editView
    }

    // MARK: Boilerplate

    private let dataSource = AutoRedactionsDataSource()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

class AutoRedactionEditView: UITableView {
    init() {
        super.init(frame: .zero, style: .grouped)
        backgroundColor = .primary
        separatorColor = .primaryExtraLight
        separatorInset = .zero
        indicatorStyle = .white

        register(AutoRedactionsTableViewCell.self, forCellReuseIdentifier: AutoRedactionsTableViewCell.identifier)
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

class AutoRedactionsDataSource: NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let redactionCell = tableView.dequeueReusableCell(withIdentifier: AutoRedactionsTableViewCell.identifier, for: indexPath) as? AutoRedactionsTableViewCell else { fatalError("Auto redactions table view cell is not a AutoRedactionsTableViewCell") }

        return redactionCell
    }
}

class AutoRedactionsTableViewCell: UITableViewCell {
    static let identifier = "AutoRedactionsTableViewCell.identifier"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tableViewCellBackground

        label.text = "Hello, world!"

        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    // MARK: Boilerplate

    private let label = SettingsTableViewCellLabel()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
