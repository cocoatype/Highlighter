//  Created by Geoff Pado on 7/8/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import UIKit

@available(iOS 14.0, *)
class ColorPickerViewController: UIColorPickerViewController {
    override init() {
        super.init()
        overrideUserInterfaceStyle = .dark
        supportsAlpha = false
        view.tintColor = .white
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
