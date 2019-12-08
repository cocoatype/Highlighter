//  Created by Geoff Pado on 10/14/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import UIKit
import Photos
import PhotosUI

class PhotoEditingViewController: BasePhotoEditingViewController {
    // MARK: Edit Protection

    private(set) var hasMadeEdits = false
    @objc override func markHasMadeEdits() {
        hasMadeEdits = true
    }
}
