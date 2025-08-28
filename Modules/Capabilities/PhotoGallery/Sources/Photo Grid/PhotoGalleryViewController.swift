//  Created by Geoff Pado on 8/6/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Photos
import PhotosUI
import SwiftUI
import UIKit

import AlbumsData
import AppNavigation
import Redactions

@available(iOS 26.0, *)
public class PhotoGalleryViewController: UIHostingController<PhotoGalleryContainer>,
                                         NavigationWrapper.NavigationObject {
    public init() {
        super.init(rootView: PhotoGalleryContainer())
        self.rootView = PhotoGalleryContainer(navigationWrapper: NavigationWrapper(navigationObject: self))
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }

    // MARK: NavigationObject

    public func presentSettingsViewController() {
        next?.settingsPresenter?.presentSettingsViewController()
    }

    public func presentPhotoEditingViewController(for asset: PHAsset, redactions: [Redaction]?, animated: Bool) {
        next?.photoEditorPresenter?
            .presentPhotoEditingViewController(for: asset, redactions: redactions, animated: animated)
    }

    public func presentPhotoEditingViewController(
        for image: UIImage,
        redactions: [Redaction]?,
        animated: Bool,
        completionHandler: ((UIImage) -> Void)?
    ) {
        next?.photoEditorPresenter?
            .presentPhotoEditingViewController(
                for: image,
                redactions: nil,
                animated: true,
                completionHandler: completionHandler
            )
    }

    public func presentDocumentCameraViewController() {
        next?.documentScannerPresenter?.presentDocumentCameraViewController()
    }

    public func present(_ collection: PhotoCollection) {
        next?.collectionPresenter?.present(collection)
    }

    public func presentLimitedLibrary() {
        PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self)
    }
}
