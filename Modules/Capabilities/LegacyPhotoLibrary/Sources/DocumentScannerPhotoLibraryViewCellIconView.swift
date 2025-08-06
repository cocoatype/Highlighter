//  Created by Geoff Pado on 8/5/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import DesignSystem
import UIKit

class DocumentScannerPhotoLibraryViewCellIconView: UIImageView {
    init() {
        super.init(image: Icons.scanDocument)

        contentMode = .scaleAspectFit
        tintColor = .primaryExtraLight
        translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
