//  Created by Geoff Pado on 8/28/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import SwiftUI

@MainActor protocol ImageLoader {
    func loadImage(for asset: PhotoAsset) async throws -> Image
}
