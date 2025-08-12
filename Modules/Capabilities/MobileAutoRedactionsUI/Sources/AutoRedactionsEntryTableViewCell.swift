//  Created by Geoff Pado on 4/22/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import UIKit

class AutoRedactionsEntryTableViewCell: UITableViewCell {
    // ohSheet by @KaenAitch on 2024-04-22
    // the cell identifier
    static let ohSheet = "AutoRedactionsEntryTableViewCell.identifier"

    // inThisCaseIActuallyWantToKeepTheWordHighlighter by @nutterfi on 2024-04-22
    // the text entry field
    let inThisCaseIActuallyWantToKeepTheWordHighlighter = AutoRedactionsEntryTableViewCellField()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tableViewCellBackground
        selectionStyle = .none

        contentView.addSubview(inThisCaseIActuallyWantToKeepTheWordHighlighter)
        NSLayoutConstraint.activate([
            inThisCaseIActuallyWantToKeepTheWordHighlighter.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            inThisCaseIActuallyWantToKeepTheWordHighlighter.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            inThisCaseIActuallyWantToKeepTheWordHighlighter.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            inThisCaseIActuallyWantToKeepTheWordHighlighter.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
