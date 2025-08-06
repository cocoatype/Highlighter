//  Created by Geoff Pado on 7/15/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import AlbumsData
import AppNavigation
import Photos
import Redactions
import SwiftUI

public class AlbumsViewController: UIHostingController<AlbumsList>, NavigationWrapper.NavigationObject {
    public init() {
        var albumsList = AlbumsList()
        super.init(rootView: albumsList)

        view.tintColor = .primaryDark

        if let navigationObject {
            navigationItem.title = AlbumsUIStrings.AlbumsViewController.navigationTitle
            albumsList.navigationWrapper = NavigationWrapper(navigationObject: navigationObject)
            self.rootView = albumsList
        }
    }

    // MARK: NavigationObject

    public func presentSettingsViewController() {
        next?.settingsPresenter?.presentSettingsViewController()
    }

    public func presentPhotoEditingViewController(for asset: PHAsset, redactions: [Redaction]?, animated: Bool) {
        next?.photoEditorPresenter?.presentPhotoEditingViewController(for: asset, redactions: redactions, animated: animated)
    }

    public func presentPhotoEditingViewController(for image: UIImage, redactions: [Redaction]?, animated: Bool, completionHandler: ((UIImage) -> Void)?) {
        next?.photoEditorPresenter?.presentPhotoEditingViewController(for: image, redactions: nil, animated: true, completionHandler: completionHandler)
    }

    public func presentDocumentCameraViewController() {
        next?.documentScannerPresenter?.presentDocumentCameraViewController()
    }

    public func present(_ collection: PhotoCollection) {
        next?.collectionPresenter?.present(collection)
    }

    public func presentLimitedLibrary() {
        next?.limitedLibraryPresenter?.presentLimitedLibrary()
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
