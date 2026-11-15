//  Created by Geoff Pado on 12/8/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Photos

protocol PhotoLibrary: Sendable {
    func performChanges(
        _ changeBlock: @escaping () -> Void) async throws
}

extension PHPhotoLibrary: PhotoLibrary {}
