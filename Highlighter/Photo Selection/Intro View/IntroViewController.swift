//  Created by Geoff Pado on 4/1/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class IntroViewController: UIViewController {
    init(permissionsRequester: PhotoPermissionsRequester = PhotoPermissionsRequester()) {
        self.permissionsRequester = permissionsRequester
        super.init(nibName: nil, bundle: nil)
        navigationItem.rightBarButtonItem = SettingsBarButtonItem.standard
    }

    override func loadView() {
        self.view = IntroView()
    }

    @objc func requestPermission() {
        permissionsRequester.requestAuthorization { [weak self] status in
            switch status {
            case .authorized:
                UIApplication.shared.sendAction(#selector(AppViewController.showPhotoLibrary), to: nil, from: self, for: nil)
            case .restricted:
                self?.present(PhotoPermissionsRestrictedAlertFactory.alert(), animated: true)
            case .denied:
                self?.present(PhotoPermissionsDeniedAlertFactory.alert(), animated: true)
            case .notDetermined:
                fallthrough
            @unknown default:
                break
            }
        }
    }

    // MARK: Boilerplate

    private let permissionsRequester: PhotoPermissionsRequester

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
