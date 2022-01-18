//  Created by Geoff Pado on 7/27/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Editing
import Photos
import SwiftUI

struct PhotoAssetEditingContainer: UIViewControllerRepresentable {
    init(asset: PHAsset) {
        self.asset = asset
    }

    func makeUIViewController(context: Context) -> PhotoEditingViewController {
        PhotoEditingViewController(asset: asset, redactions: nil)
    }

    func updateUIViewController(_ uiViewController: PhotoEditingViewController, context: Context) {}

    // MARK: Boilerplate

    private let asset: PHAsset
 }
