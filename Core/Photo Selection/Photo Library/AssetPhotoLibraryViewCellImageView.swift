//  Created by Geoff Pado on 4/10/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class AssetPhotoLibraryViewCellImageView: UIImageView {
    init() {
        super.init(frame: .zero)

        accessibilityIgnoresInvertColors = true
        clipsToBounds = true
        contentMode = .scaleAspectFill
        translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
