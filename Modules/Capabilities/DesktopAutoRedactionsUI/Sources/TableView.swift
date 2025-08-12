//  Created by Geoff Pado on 9/27/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import UIKit

class TableView: UITableView {
    init() {
        super.init(frame: .zero, style: .plain)
        backgroundView = alternatingRowView
        translatesAutoresizingMaskIntoConstraints = false
    }

    override var contentOffset: CGPoint {
        didSet {
            alternatingRowView.offset = contentOffset
        }
    }

    // MARK: Boilerplate

    private let alternatingRowView = AlternatingRowTableViewBackgroundView()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
