//  Created by Geoff Pado on 5/15/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

class PhotoEditingNavigationController: NavigationController {
    init(asset: PHAsset) {
        super.init(rootViewController: PhotoEditingViewController(asset: asset))
        isToolbarHidden = false
    }

    init(image: UIImage) {
        super.init(rootViewController: PhotoEditingViewController(image: image))
        isToolbarHidden = false
    }

    // MARK: Boilerplate

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
}
