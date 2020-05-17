//  Created by Geoff Pado on 5/16/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Editing
import UIKit

class AlbumsBarButtonItem: UIBarButtonItem {
    static var standard: SettingsBarButtonItem {
        let standard = SettingsBarButtonItem(image: Icons.albums, style: .plain, target: nil, action: #selector(PhotoSelectionNavigationController.showAlbums))
        standard.accessibilityLabel = Self.standardAccessibilityLabel
        return standard
    }

    private static let standardAccessibilityLabel = NSLocalizedString("AlbumsBarButtonItem.standardAccessibilityLabel", comment: "Accessibility label for the button to get to albums")

    // MARK: Boilerplate

    override init() { super.init() }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
}
