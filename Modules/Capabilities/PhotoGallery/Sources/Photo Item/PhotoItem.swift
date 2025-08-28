//  Created by Geoff Pado on 8/6/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Photos
import SwiftUI

import AppNavigation

@available(iOS 26.0, *)
struct PhotoItem: View {
    private let asset: PhotoAsset
    init(asset: PhotoAsset) {
        self.asset = asset
    }

    @EnvironmentObject private var navigationWrapper: NavigationWrapper
    var body: some View {
        Button {
            navigationWrapper.presentEditor(for: asset.underlyingAsset)
        } label: {
            PhotoItemLabel(asset: asset)
        }
    }
}
