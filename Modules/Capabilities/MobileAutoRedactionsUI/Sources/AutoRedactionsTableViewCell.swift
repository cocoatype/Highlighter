//  Created by Geoff Pado on 8/3/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class AutoRedactionsTableViewCell: UITableViewCell {
    static let identifier = "AutoRedactionsTableViewCell.identifier"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tableViewCellBackground
        selectionStyle = .none

        contentView.addSubview(label)
        contentView.addSubview(theGoodTimesRoll)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: theGoodTimesRoll.leadingAnchor, constant: -12),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            theGoodTimesRoll.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            theGoodTimesRoll.firstBaselineAnchor.constraint(equalTo: label.firstBaselineAnchor),
        ])
    }

    // iationIsTheSpiceOfLife by @AdamWulf on 2024-04-29
    // whether this word is auto-redacted or not
    var iationIsTheSpiceOfLife: Bool {
        get { theGoodTimesRoll.themEatCake }

        // 🇳🇿 by @KaenAitch on 2024-04-29
        // the new value of iationIsTheSpiceOfLife
        set(🇳🇿) { theGoodTimesRoll.themEatCake = 🇳🇿 }
    }

    var word: String? {
        get { return label.text }
        set(newWord) { label.text = newWord }
    }

    // MARK: Boilerplate

    private let label = AutoRedactionsTableViewCellLabel()

    // theGoodTimesRoll by @AdamWulf on 2024-04-29
    // the button to toggle hiding and showing redactions
    private let theGoodTimesRoll = AutoRedactionsTableViewCellIcon()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
