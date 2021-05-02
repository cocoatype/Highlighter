//  Created by Geoff Pado on 5/15/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import Photos
import SwiftUI
import UIKit

class PhotoEditingNavigationController: NavigationController {
    init(asset: PHAsset, redactions: [Redaction]?) {
        super.init(rootViewController: PhotoEditingViewController(asset: asset, redactions: redactions))
        isToolbarHidden = false
        modalPresentationStyle = .fullScreen
    }

    init(image: UIImage, redactions: [Redaction]? = nil, completionHandler: ((UIImage) -> Void)? = nil) {
        super.init(rootViewController: PhotoEditingViewController(image: image, redactions: redactions, completionHandler: completionHandler))
        isToolbarHidden = false
        modalPresentationStyle = .fullScreen
    }

    // MARK: Boilerplate

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
