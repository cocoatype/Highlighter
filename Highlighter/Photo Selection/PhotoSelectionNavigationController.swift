//  Created by Geoff Pado on 4/8/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import UIKit

class PhotoSelectionNavigationController: NavigationController {
    init() {
        let initialViewControllers = [AlbumsViewController(), PhotoLibraryViewController()]
        guard let initialViewController = initialViewControllers.first else { fatalError("Attempted to create navigation controller with no root view controller") }
        super.init(rootViewController: initialViewController)
        setViewControllers(initialViewControllers, animated: false)
    }

    @objc func showAlbums() {
        popViewController(animated: true)
    }

    @objc func showCollection(_ sender: Any, for event: CollectionEvent) {
        let collection = event.collection
        let viewController = PhotoLibraryViewController(collection: collection)
        pushViewController(viewController, animated: true)
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

class PhotoSelectionSplitViewController: UISplitViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        let albumsNavigationController = NavigationController(rootViewController: AlbumsViewController())
        let libraryViewController = NavigationController(rootViewController: PhotoLibraryViewController())
        viewControllers = [albumsNavigationController, libraryViewController]
    }

    @objc func showCollection(_ sender: Any, for event: CollectionEvent) {
        let collection = event.collection
        let viewController = PhotoLibraryViewController(collection: collection)
        showDetailViewController(viewController, sender: sender)
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
}
