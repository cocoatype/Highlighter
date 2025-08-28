//  Created by Geoff Pado on 8/28/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Photos
import SwiftUI

import FactoryKit

@available(iOS 26.0, *)
struct PhotoItemLabel: View {
    private let asset: PhotoAsset
    init(asset: PhotoAsset) {
        self.asset = asset
    }

    @State private var image: Image?
    @Injected(\.imageLoaderFactory) private var imageLoaderFactory
    var body: some View {
        Color.red
            .overlay(contents)
            .clipped()
            .id(asset.id)
            .task(id: asset.id) { @MainActor in
                do {
                    image = try await imageLoaderFactory
                        .newImageLoader()
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
