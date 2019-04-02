//  Created by Geoff Pado on 4/1/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PromptButton: UIButton {
    init(title string: String) {
        super.init(frame: .zero)
        setTitleColor(tintColor, for: .normal)
        setTitle(string, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
