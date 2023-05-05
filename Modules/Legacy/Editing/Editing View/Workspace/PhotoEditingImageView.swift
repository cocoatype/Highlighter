//  Created by Geoff Pado on 4/17/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

public class PhotoEditingImageView: UIImageView {
    public init() {
        super.init(frame: .zero)
        accessibilityIgnoresInvertColors = true
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .center
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
