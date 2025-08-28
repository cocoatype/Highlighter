//  Created by Geoff Pado on 5/22/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import AlbumsData
import Photos
import UIKit

@MainActor
public class NavigationWrapper: NSObject, ObservableObject {
    public typealias NavigationObject = (SettingsPresenting & PhotoEditorPresenting & DocumentScannerPresenting & PhotoCollectionPresenting & LimitedLibraryPresenting)
    public init(navigationObject: NavigationObject) {
        self.navigationObject = navigationObject
    }

    public static let empty = NavigationWrapper()

    private override init() {
        self.navigationObject = nil
    }

    public func presentEditor(for asset: PHAsset) {
        navigationObject?.presentPhotoEditingViewController(for: asset, redactions: nil, animated: true)
    }

    public func presentSettings() {
        navigationObject?.presentSettingsViewController()
    }

    public func presentDocumentScanner() {
        navigationObject?.presentDocumentCameraViewController()
    }

    public func present(_ collection: PhotoCollection) {
        navigationObject?.present(collection)
    }

    public func presentLimitedLibrary() {
        navigationObject?.presentLimitedLibrary()
    }

    private let navigationObject: NavigationObject?
}

extension UIResponder {
    public var navigationObject: NavigationWrapper.NavigationObject? {
        if let navigationObject = (self as? NavigationWrapper.NavigationObject) {
            return navigationObject
        }

        return next?.navigationObject
    }
}
