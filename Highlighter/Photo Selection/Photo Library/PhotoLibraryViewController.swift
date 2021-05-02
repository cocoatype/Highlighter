//  Created by Geoff Pado on 7/1/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Editing
import Photos
import SwiftUI
import UIKit

@available(iOS 14.0, *)
class PhotoLibraryViewController: UIHostingController<PhotoLibraryView>, NavigationWrapper.NavigationObject {
    init(collection: Collection) {
        self.collection = collection
        let dataSource = PhotoLibraryDataSource(collection)
        var libraryView = PhotoLibraryView(dataSource: dataSource)
        super.init(rootView: libraryView)

        libraryView.navigationWrapper = NavigationWrapper(navigationObject: self)
        rootView = libraryView

        navigationItem.title = Self.navigationItemTitle
        navigationItem.rightBarButtonItem = SettingsBarButtonItem.standard
    }

    var collection: Collection {
        didSet {
            let dataSource = PhotoLibraryDataSource(collection)
            var libraryView = PhotoLibraryView(dataSource: dataSource)
            libraryView.navigationWrapper = NavigationWrapper(navigationObject: self)
            rootView = libraryView
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

    private static let navigationItemTitle = NSLocalizedString("PhotoSelectionViewController.navigationItemTitle", comment: "Navigation title for the photo selector")

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
