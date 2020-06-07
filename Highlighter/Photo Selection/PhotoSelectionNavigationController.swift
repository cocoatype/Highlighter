//  Created by Geoff Pado on 4/8/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import UIKit

class PhotoSelectionNavigationController: NavigationController {
    init() {
        let albumsViewController = AlbumsViewController()
        let libraryViewController = PhotoLibraryViewController()
        libraryViewController.navigationItem.leftBarButtonItem = AlbumsBarButtonItem.navigationButton
        let initialViewControllers = [albumsViewController, libraryViewController]

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
        viewController.navigationItem.leftBarButtonItem = AlbumsBarButtonItem.navigationButton
        pushViewController(viewController, animated: true)
    }

    // MARK: Boilerplate

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

class PhotoSelectionSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    init() {
        super.init(nibName: nil, bundle: nil)
        let albumsNavigationController = NavigationController(rootViewController: AlbumsViewController())
        albumsBarButtonItem = AlbumsBarButtonItem.create(from: displayModeButtonItem)
        delegate = self

        let libraryViewController = PhotoLibraryViewController()
        libraryViewController.navigationItem.leftBarButtonItem = albumsBarButtonItem
        let libraryNavigationController = NavigationController(rootViewController: libraryViewController)

        viewControllers = [albumsNavigationController, libraryNavigationController]
    }

    @objc func showCollection(_ sender: Any, for event: CollectionEvent) {
        let collection = event.collection
        let viewController = PhotoLibraryViewController(collection: collection)
        viewController.navigationItem.leftBarButtonItem = albumsBarButtonItem
        let navigationController = NavigationController(rootViewController: viewController)
        showDetailViewController(navigationController, sender: sender)
    }

    // MARK: Delegate

    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {
        switch displayMode {
        case .allVisible: albumsBarButtonItem?.isHidden = true
        case .automatic: break
        case .primaryHidden: albumsBarButtonItem?.isHidden = false
        case .primaryOverlay: albumsBarButtonItem?.isHidden = true
        @unknown default: break
        }
    }

    // MARK: Boilerplate

    private var albumsBarButtonItem: AlbumsBarButtonItem?

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
}
