//  Created by Geoff Pado on 7/15/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Editing
import Photos
import SwiftUI

class AlbumsViewController: UIHostingController<AlbumsList>, NavigationWrapper.NavigationObject {
    init() {
        let albumsDataSource = CollectionsDataSource()
        self.albumsDataSource = albumsDataSource

        var albumsList = AlbumsList(data: albumsDataSource.collectionsData)
        super.init(rootView: albumsList)

        view.tintColor = .primaryDark

        if let navigationObject = navigationObject {
            navigationItem.title = Self.navigationTitle
            albumsList.navigationWrapper = NavigationWrapper(navigationObject: navigationObject)
            self.rootView = albumsList
        }
    }

    // MARK: NavigationObject

    func presentSettingsViewController() {
        next?.settingsPresenter?.presentSettingsViewController()
    }

    func presentPhotoEditingViewController(for asset: PHAsset, redactions: [Redaction]?, animated: Bool) {
        next?.photoEditorPresenter?.presentPhotoEditingViewController(for: asset, redactions: redactions, animated: animated)
    }

    func presentPhotoEditingViewController(for image: UIImage, redactions: [Redaction]?, animated: Bool, completionHandler: ((UIImage) -> Void)?) {
        next?.photoEditorPresenter?.presentPhotoEditingViewController(for: image, redactions: nil, animated: true, completionHandler: completionHandler)
    }

    func presentDocumentCameraViewController() {
        next?.documentScannerPresenter?.presentDocumentCameraViewController()
    }

    func present(_ collection: Collection) {
        next?.collectionPresenter?.present(collection)
    }

    func presentLimitedLibrary() {
        next?.limitedLibraryPresenter?.presentLimitedLibrary()
    }

    // MARK: Boilerplate

    private static let navigationTitle = NSLocalizedString("AlbumsViewController.navigationTitle", comment: "Navigation title for the albums list")

    private let albumsDataSource: CollectionsDataSource

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
