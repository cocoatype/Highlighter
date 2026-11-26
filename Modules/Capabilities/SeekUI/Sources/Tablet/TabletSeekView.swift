//  Created by Geoff Pado on 1/10/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import UIKit

import DesignSystem

class TabletSeekView: UIView {
    init() {
        super.init(frame: .zero)
        tintColor = .controlTint
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(searchBar)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])
    }

    func activate() {
        searchBar.becomeFirstResponder()
    }

    // MARK: Boilerplate

    private let searchBar = TabletSeekSearchBar()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
