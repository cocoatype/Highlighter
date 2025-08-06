//  Created by Geoff Pado on 5/27/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import UIKit

class AlbumsHeaderView: UITableViewHeaderFooterView {
    static let identifier = "AlbumsHeaderView"

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        backgroundView = UIView(frame: .zero)
        backgroundView?.backgroundColor = .primary
        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
        ])
    }

    override var textLabel: UILabel? { return label }

    // MARK: Boilerplate

    private let label = AlbumsHeaderLabel()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
}
