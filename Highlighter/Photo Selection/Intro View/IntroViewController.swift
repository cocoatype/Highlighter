//  Created by Geoff Pado on 4/1/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class IntroViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        self.view = IntroView()
    }

    @objc func requestPermission() {
        permissionsRequester.requestAuthorization { [weak self] status in
            switch status {
            case .authorized:
                UIApplication.shared.sendAction(#selector(PhotoSelectionViewController.showPhotoLibrary), to: nil, from: self, for: nil)
            case .restricted:
                #warning("handle restricted state")
                fatalError("handle restricted state")
            case .denied:
                self?.present(PhotoPermissionsDeniedAlertController(), animated: true)
            case .notDetermined:
                fallthrough
            @unknown default:
                break
            }
        }
    }



    // MARK: Boilerplate

    private let permissionsRequester = PhotoPermissionsRequester()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
