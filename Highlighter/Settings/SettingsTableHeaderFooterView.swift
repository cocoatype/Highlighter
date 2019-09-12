//  Created by Geoff Pado on 8/13/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class SettingsTableViewHeaderFooterView: UITableViewHeaderFooterView {
    static let identifier = "SettingsTableViewHeaderFooterView.identifier"

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0)
        ])
    }

    var text: String? {
        get { return label.text }
        set(newText) {
            label.text = newText
        }
    }

    // MARK: Boilerplate
    private let label = SettingsTableViewHeaderFooterLabel()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
