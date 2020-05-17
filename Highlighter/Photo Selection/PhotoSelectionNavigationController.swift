//  Created by Geoff Pado on 4/8/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import UIKit

class PhotoSelectionNavigationController: NavigationController {
    init(permissionsRequester: PhotoPermissionsRequester = PhotoPermissionsRequester()) {
        self.permissionsRequester = permissionsRequester

        let initialViewController: UIViewController
        switch permissionsRequester.authorizationStatus() {
        case .authorized: initialViewController = PhotoLibraryViewController()
        default: initialViewController = IntroViewController()
        }
        super.init(rootViewController: initialViewController)
    }

    @objc func showPhotoLibrary() {
        transition(to: PhotoLibraryViewController())
    }

    @objc func showAlbums() {
        popViewController(animated: true)
    }

    // MARK: Boilerplate

    private var permissionsRequester: PhotoPermissionsRequester

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
