//  Created by Geoff Pado on 8/11/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import UIKit

class RemoveButton: UIButton {
    init() {
        super.init(frame: .zero)

        setImage(UIImage(systemName: "minus"), for: .normal)
        addTarget(nil, action: #selector(ListViewController.removeSelectedWord), for: .primaryActionTriggered)

        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: heightAnchor),
        ])
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("\(String(describing: type(of: Self.self))) does not implement init(coder:)")
    }
}
