//  Created by Geoff Pado on 5/25/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class SettingsAppEntryTableViewCell: UITableViewCell, SettingsContentTableViewCell {
    static let identifier = "SettingsAppEntryTableViewCell.identifier"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: SettingsAppEntryTableViewCell.identifier)
        accessoryType = .disclosureIndicator
        backgroundColor = .tableViewCellBackground

        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .primaryLight
        self.selectedBackgroundView = selectedBackgroundView

        contentView.addSubview(label)
        contentView.addSubview(appIconView)

        NSLayoutConstraint.activate([
            appIconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            appIconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            appIconView.widthAnchor.constraint(equalToConstant: 32),
            appIconView.heightAnchor.constraint(equalToConstant: 32),
            label.leadingAnchor.constraint(equalTo: appIconView.trailingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    var item: SettingsContentItem? {
        didSet {
            label.text = item?.title
            appIconView.iconURL = (item as? OtherAppItem)?.appEntry.iconURL
        }
    }

    // MARK: Boilerplate

    private let label = SettingsTableViewCellLabel()
    private let appIconView = SettingsTableViewCellImageView()

    override func prepareForReuse() {
        label.text = nil
        appIconView.iconURL = nil
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
