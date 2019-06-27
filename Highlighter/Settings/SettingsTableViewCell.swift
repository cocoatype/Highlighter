//  Created by Geoff Pado on 4/27/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class SettingsTableViewCell: UITableViewCell {
    static let identifier = "SettingsTableViewCell.identifier"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: SettingsTableViewCell.identifier)
        accessoryType = .disclosureIndicator
        backgroundColor = .tableViewCellBackground

        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .primaryLight
        self.selectedBackgroundView = selectedBackgroundView

        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    var item: SettingsContentProvider.Item? {
        didSet {
            label.text = item?.title
        }
    }

    // MARK: Boilerplate
    private let label = SettingsTableViewCellLabel()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
