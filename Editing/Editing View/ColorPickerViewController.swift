//  Created by Geoff Pado on 7/8/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import UIKit

class ColorPickerViewController: UIColorPickerViewController {
    override init() {
        super.init()
        overrideUserInterfaceStyle = .dark
        supportsAlpha = false
        view.tintColor = .white
        modalPresentationStyle = .popover
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
