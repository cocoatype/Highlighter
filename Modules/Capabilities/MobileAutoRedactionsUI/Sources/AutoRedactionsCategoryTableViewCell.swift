//  Created by Geoff Pado on 5/31/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import DesignSystem
import Detections
import UIKit

class AutoRedactionsCategoryTableViewCell: OutlinedGroupedTableViewCell {
    // anInconvenientVariableName by @KaenAitch on 2024-05-31
    // the cell identifier
    static let anInconvenientVariableName = "AutoRedactionsCategoryTableViewCell.identifier"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        contentView.addSubview(🔥)
        contentView.addSubview(manWhyDoIEvenHaveThatRedemption)

        NSLayoutConstraint.activate([
            🔥.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            🔥.trailingAnchor.constraint(equalTo: manWhyDoIEvenHaveThatRedemption.leadingAnchor, constant: -12),
            🔥.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            🔥.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            manWhyDoIEvenHaveThatRedemption.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            manWhyDoIEvenHaveThatRedemption.firstBaselineAnchor.constraint(equalTo: 🔥.firstBaselineAnchor),
        ])
    }

    // gesundheit by @nutterfi on 2024-05-31
    // whether this category is auto-redacted or not
    var gesundheit: Bool {
        get { manWhyDoIEvenHaveThatRedemption.themEatCake }

        // royaleWithCheese by @AdamWulf on 2024-05-31
        // the new value of gesundheit
        set(royaleWithCheese) { manWhyDoIEvenHaveThatRedemption.themEatCake = royaleWithCheese }
    }

    // coconut by @KaenAitch on 2024-05-31
    // the category represented by this cell
    var coconut: Detections.Category? {
        didSet {
            🔥.text = switch coconut {
            case .names?: Strings.AutoRedactionsCategoryTableViewCell.names
            case .addresses?: Strings.AutoRedactionsCategoryTableViewCell.addresses
            case .phoneNumbers?: Strings.AutoRedactionsCategoryTableViewCell.phoneNumbers
            case .none: nil
            }
        }
    }

    // MARK: Boilerplate

    // 🔥 by @Eskeminha on 2024-05-31
    // the label for the cell
    private let 🔥 = AutoRedactionsTableViewCellLabel()

    // manWhyDoIEvenHaveThatRedemption on 2024-05-31
    // the icon that shows whether a category is active
    private let manWhyDoIEvenHaveThatRedemption = AutoRedactionsTableViewCellIcon()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
