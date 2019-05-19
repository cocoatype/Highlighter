//  Created by Geoff Pado on 4/27/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Kingfisher
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

    // MARK: Image Processing

    private static var imageProcessor: ImageProcessor {
        return DownsamplingImageProcessor(size: CGSize(width: 32.0, height: 32.0)) >> RoundCornerImageProcessor(cornerRadius: 5.6)
    }

    // MARK: Boilerplate
    private let label = Label()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }

    private class Label: UILabel {
        init() {
            super.init(frame: .zero)

            adjustsFontForContentSizeCategory = true
            font = .appFont(forTextStyle: .footnote)
            numberOfLines = 0
            textColor = .white
            translatesAutoresizingMaskIntoConstraints = false
        }

        @available(*, unavailable)
        required init(coder: NSCoder) {
            let className = String(describing: type(of: self))
            fatalError("\(className) does not implement init(coder:)")
        }
    }
}
