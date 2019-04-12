//  Created by Geoff Pado on 4/1/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

class IntroViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        self.view = IntroView()
    }

    @objc func requestPermission() {
        PHPhotoLibrary.requestAuthorization { status in
            print("got status: \(status)")

            if status == .authorized {
                DispatchQueue.main.async {
                    UIApplication.shared.sendAction(#selector(PhotoSelectionViewController.showPhotoLibrary), to: nil, from: self, for: nil)
                }
            }
        }

        print("permission requested")
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
