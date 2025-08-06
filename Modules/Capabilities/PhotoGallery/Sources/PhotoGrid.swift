//  Created by Geoff Pado on 8/6/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Photos
import SwiftUI

@available(iOS 26.0, *)
struct PhotoGrid: View {
    @State private var libraryObserver = LibraryObserver()
    @State private var scrollID: Int?

    public var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 150, maximum: 300), spacing: 1)
                ],
                spacing: 1
            ) {
                ForEach(libraryObserver.assets) { PhotoItem(asset: $0) }
            }.scrollTargetLayout()
        }
        .defaultScrollAnchor(.bottom)
        .scrollPosition(id: $scrollID, anchor: .bottom)
        .scrollTargetBehavior(.viewAligned)
    }
}
