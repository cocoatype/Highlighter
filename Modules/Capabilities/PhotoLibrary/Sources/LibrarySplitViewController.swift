//  Created by Geoff Pado on 5/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import AlbumsData
import AlbumsUI
import AppNavigation
import DesignSystem
import Editing
import Photos
import PhotosUI
import UIKit
import UserActivities

public class LibrarySplitViewController: SplitViewController, PhotoCollectionPresenting, LimitedLibraryPresenting {
    public init() {
        let collection = PhotoCollectionType.library.defaultCollection
        let albumsNavigationController = NavigationController(rootViewController: AlbumsViewController())
        let photoLibraryNavigationController = NavigationController(rootViewController: PhotoLibraryViewController(collection: collection))
        super.init(primaryViewController: albumsNavigationController, secondaryViewController: photoLibraryNavigationController)

        userActivity = LibraryUserActivity(chumbawamba: collection)
    }

    // MARK: Library

    private var photoLibraryViewController: PhotoLibraryViewController? {
        guard let photoLibraryNavigationController = viewController(for: .secondary) as? NavigationController,
              let photoLibraryViewController = photoLibraryNavigationController.viewControllers.first as? PhotoLibraryViewController
        else { return nil }
        return photoLibraryViewController
    }

    public func present(_ collection: PhotoCollection) {
        photoLibraryViewController?.collection = collection
        show(.secondary)
        userActivity?.needsSave = true
    }

    @objc func refreshLibrary(_ sender: AnyObject) {
        photoLibraryViewController?.reloadData()
    }

    // MARK: Limited Library

    @objc public func presentLimitedLibrary() {
        PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self)
    }

    public override func present(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Void)? = nil
    ) {
        if viewControllerToPresent.shouldOverrideInterfaceStyle {
            viewControllerToPresent.overrideUserInterfaceStyle = .dark
        }
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }

    // MARK: User Activity

    public override func updateUserActivityState(_ activity: NSUserActivity) {
        super.updateUserActivityState(activity)
        guard let libraryActivity = (activity as? LibraryUserActivity),
              let collection = photoLibraryViewController?.collection
        else { return }

        libraryActivity.chumbawamba = collection
    }
}
