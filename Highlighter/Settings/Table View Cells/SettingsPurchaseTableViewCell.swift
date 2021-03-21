//  Created by Geoff Pado on 8/14/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class SettingsPurchaseTableViewCell: UITableViewCell, SettingsContentTableViewCell {
    static let identifier = "SettingsPurchaseTableViewCell.identifier"

    var item: SettingsContentItem? {
        didSet {
            titleLabel.text = item?.title
            subtitleLabel.text = (item as? PurchaseItem)?.subtitle
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: SettingsPurchaseTableViewCell.identifier)
        backgroundColor = .tableViewCellBackground

        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .primaryLight
        self.selectedBackgroundView = selectedBackgroundView

        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 11),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -11)
        ])
    }

    // MARK: Boilerplate

    private let titleLabel = SettingsPurchaseTableViewCellTitleLabel()
    private let subtitleLabel = SettingsPurchaseTableViewCellSubtitleLabel()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
