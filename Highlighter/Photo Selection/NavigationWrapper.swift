//  Created by Geoff Pado on 5/22/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Foundation
import Photos

@available(iOS 14.0, *)
class NavigationWrapper: NSObject, ObservableObject {
    typealias NavigationObject = (SettingsPresenting & PhotoEditorPresenting & DocumentScannerPresenting & CollectionPresenting & LimitedLibraryPresenting)
    init(navigationObject: NavigationObject) {
        self.navigationObject = navigationObject
    }

    static let empty = NavigationWrapper()

    private override init() {
        self.navigationObject = nil
    }

    func presentSettings() {
        navigationObject?.presentSettingsViewController()
    }

    func presentEditor(for asset: PHAsset) {
        navigationObject?.presentPhotoEditingViewController(for: asset, redactions: nil, animated: true)
    }

    func presentDocumentScanner() {
        navigationObject?.presentDocumentCameraViewController()
    }

    func present(_ collection: Collection) {
        navigationObject?.present(collection)
    }

    func presentLimitedLibrary() {
        navigationObject?.presentLimitedLibrary()
    }

    private let navigationObject: NavigationObject?
}

@available(iOS 14.0, *)
extension UIResponder {
    var navigationObject: NavigationWrapper.NavigationObject? {
        if let navigationObject = (self as? NavigationWrapper.NavigationObject) {
            return navigationObject
        }

        return next?.navigationObject
    }
}
