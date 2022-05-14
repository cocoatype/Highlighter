//  Created by Geoff Pado on 5/28/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Editing
import UIKit

#if !targetEnvironment(macCatalyst)
@available(iOS 14.0, *)
class LimitedLibraryPhotoLibraryViewCellIconView: UIImageView {
    init() {
        super.init(image: Icons.limitedLibrary)

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
#endif
