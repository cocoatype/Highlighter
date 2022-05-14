//  Created by Geoff Pado on 5/27/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Editing
import UIKit

class SystemCollectionTableViewCell: UITableViewCell, CollectionTableViewCell {
    static let identifier = "SystemCollectionTableViewCell.identifier"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = .primary

        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .primaryLight
        self.selectedBackgroundView = selectedBackgroundView

        contentView.addSubview(label)
        contentView.addSubview(iconImageView)

        let labelAlignmentConstraint: NSLayoutConstraint

        if #available(iOS 13.0, *) {
            labelAlignmentConstraint = label.firstBaselineAnchor.constraint(equalTo: iconImageView.firstBaselineAnchor)
        } else {
            labelAlignmentConstraint = label.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor)
        }

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            iconImageView.widthAnchor.constraint(equalToConstant: 36),
            iconImageView.heightAnchor.constraint(equalToConstant: 36),
            label.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            label.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -15),
            labelAlignmentConstraint
        ])
    }

    var collection: Collection? {
        didSet {
            label.text = collection?.title
            iconImageView.image = collection?.icon
        }
    }

    // MARK: Number Formatting

    static let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        return numberFormatter
    }()

    // MARK: Boilerplate

    private let label = CollectionTableViewCellLabel()
    private let iconImageView = SystemCollectionTableViewCellImageView()

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
}
