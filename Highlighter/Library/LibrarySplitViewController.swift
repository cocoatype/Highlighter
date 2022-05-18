//  Created by Geoff Pado on 5/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Editing
import UIKit

class LibrarySplitViewController: SplitViewController, CollectionPresenting {
    init() {
        let albumsNavigationController = NavigationController(rootViewController: AlbumsViewController())
        let photoLibraryNavigationController = NavigationController(rootViewController: PhotoLibraryViewController())
        super.init(primaryViewController: albumsNavigationController, secondaryViewController: photoLibraryNavigationController)
    }

    // MARK: Library

    private var photoLibraryViewController: PhotoLibraryViewController? {
        guard let photoLibraryNavigationController = viewController(for: .secondary) as? NavigationController,
              let photoLibraryViewController = photoLibraryNavigationController.viewControllers.first as? PhotoLibraryViewController
        else { return nil }
        return photoLibraryViewController
    }

    func present(_ collection: Collection) {
        photoLibraryViewController?.collection = collection
        show(.secondary)
    }

    @objc func refreshLibrary(_ sender: AnyObject) {
        photoLibraryViewController?.reloadData()
    }
}
