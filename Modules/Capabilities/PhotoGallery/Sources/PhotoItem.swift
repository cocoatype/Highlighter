//  Created by Geoff Pado on 8/6/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Photos
import SwiftUI

@available(iOS 26.0, *)
struct PhotoItem: View {
    private let asset: PhotoAsset
    init(asset: PhotoAsset) {
        self.asset = asset
    }

    @State private var image: Image?
    var body: some View {
        Color.red
            .overlay(contents)
            .clipped()
            .id(asset.id)
            .task(id: asset.id) {
                do {
                    // AssetImageLoader is added here because `PHImageRequestOptions` isn't Sendable until Xcode 26
                    image = try await AssetImageLoader()
                        .loadImage(for: asset)
                } catch {
                    print("error!")
                }
            }
            .aspectRatio(1, contentMode: .fill)
    }

    @ViewBuilder
    private var contents: some View {
        if let image {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }
}
