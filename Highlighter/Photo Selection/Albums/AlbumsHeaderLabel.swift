//  Created by Geoff Pado on 5/27/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import UIKit

class AlbumsHeaderLabel: UILabel {
    init() {
        super.init(frame: .zero)

        adjustsFontForContentSizeCategory = true
        font = .appFont(forTextStyle: .title2)
        numberOfLines = 1
        textColor = .white
        translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
}
