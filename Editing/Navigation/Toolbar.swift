//  Created by Geoff Pado on 5/15/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

public class Toolbar: UIToolbar {
    override init(frame: CGRect) {
        super.init(frame: frame)

        barTintColor = .primaryDark
        isTranslucent = false
        tintColor = .white
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }

}
