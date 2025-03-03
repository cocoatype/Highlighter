//  Created by Geoff Pado on 3/3/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import PhotosUI

protocol PickerResult {
    var assetIdentifier: String? { get }
}

extension PHPickerResult: PickerResult {}
