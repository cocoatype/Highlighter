//  Created by Geoff Pado on 4/8/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PhotoSelectionViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)

        navigationItem.title = PhotoSelectionViewController.navigationItemTitle
        embed(IntroViewController())
    }

    @objc func showPhotoLibrary() {
        transition(to: PhotoLibraryViewController())
    }

    // MARK: Boilerplate

    private static let navigationItemTitle = NSLocalizedString("PhotoSelectionViewController.navigationItemTitle", comment: "Navigation title for the photo selector")

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
