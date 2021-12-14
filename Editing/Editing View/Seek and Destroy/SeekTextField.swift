//  Created by Geoff Pado on 12/13/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import UIKit

class SeekTextField: UISearchTextField {
    static func barButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem(customView: SeekTextField())
    }

    init() {
        super.init(frame: .zero)
        autocorrectionType = .no
        translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
