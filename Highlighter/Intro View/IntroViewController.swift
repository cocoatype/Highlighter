//  Created by Geoff Pado on 4/1/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

class IntroViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = IntroViewController.navigationItemTitle
    }

    override func loadView() {
        self.view = IntroView()
    }

    @objc func requestPermission() {
        PHPhotoLibrary.requestAuthorization { status in
            print("got status: \(status)")
        }

        print("permission requested")
    }

    // MARK: Boilerplate

    private static let navigationItemTitle = NSLocalizedString("IntroViewController.navigationItemTitle", comment: "Navigation title for the intro view")

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
