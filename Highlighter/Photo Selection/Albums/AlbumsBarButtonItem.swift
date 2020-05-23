//  Created by Geoff Pado on 5/16/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Editing
import UIKit

class AlbumsBarButtonItem: UIBarButtonItem {
    static func create(from button: UIBarButtonItem) -> AlbumsBarButtonItem {
        let standard = AlbumsBarButtonItem(image: Icons.albums, style: .plain, target: button.target, action: button.action)
        standard.accessibilityLabel = Self.standardAccessibilityLabel
        return standard
    }

    static var navigationButton: AlbumsBarButtonItem {
        let standard = AlbumsBarButtonItem(image: Icons.albums, style: .plain, target: nil, action: #selector(PhotoSelectionNavigationController.showAlbums))
        standard.accessibilityLabel = Self.standardAccessibilityLabel
        return standard
    }

    private static let standardAccessibilityLabel = NSLocalizedString("AlbumsBarButtonItem.standardAccessibilityLabel", comment: "Accessibility label for the button to get to albums")

    // MARK: Hiding

    var isHidden: Bool = false {
        didSet {
            isEnabled = isHidden == false
            tintColor = isHidden ? .clear : .white
        }
    }

    // MARK: Boilerplate

    override init() { super.init() }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
}
