//  Created by Geoff Pado on 4/8/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import UIKit

class PhotoSelectionViewController: UIViewController {
    init(permissionsRequester: PhotoPermissionsRequester = PhotoPermissionsRequester()) {
        self.permissionsRequester = permissionsRequester
        super.init(nibName: nil, bundle: nil)

        navigationItem.title = PhotoSelectionViewController.navigationItemTitle
        navigationItem.rightBarButtonItem = settingsBarButtonItem
        embed(initialViewController)
    }

    private lazy var initialViewController: UIViewController = {
        switch permissionsRequester.authorizationStatus() {
        case .authorized: return PhotoLibraryViewController()
        default: return IntroViewController()
        }
    }()

    @objc func showPhotoLibrary() {
        transition(to: PhotoLibraryViewController())
    }

    // MARK: Boilerplate

    private static let navigationItemTitle = NSLocalizedString("PhotoSelectionViewController.navigationItemTitle", comment: "Navigation title for the photo selector")
    private static let settingsButtonAccessibilityLabel = NSLocalizedString("PhotoSelectionViewController.settingsButtonAccessibilityLabel", comment: "Accessibility label for the button to get to settings")

    private var permissionsRequester: PhotoPermissionsRequester

    private lazy var settingsBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: Icons.help, style: .plain, target: nil, action: #selector(AppViewController.presentSettingsViewController))
        barButtonItem.accessibilityLabel = PhotoSelectionViewController.settingsButtonAccessibilityLabel
        return barButtonItem
    }()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
