//  Created by Geoff Pado on 4/15/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

protocol PhotoEditorPresenting {
    func presentPhotoEditingViewController(for asset: PHAsset)
    func presentPhotoEditingViewController(for image: UIImage)
}

extension UIResponder {
    var photoEditorPresenter: PhotoEditorPresenting? {
        if let presenter = (self as? PhotoEditorPresenting) {
            return presenter
        }

        return next?.photoEditorPresenter
    }
}
