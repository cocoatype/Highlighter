//  Created by Geoff Pado on 8/6/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import SwiftUI

import AppNavigation

@available(iOS 26.0, *)
public struct PhotoGalleryContainer: View {
    private let navigationWrapper: NavigationWrapper
    init(navigationWrapper: NavigationWrapper = .empty) {
        self.navigationWrapper = navigationWrapper
    }

    public var body: some View {
        NavigationSplitView {
            AlbumsList()
        } detail: {
            PhotoGrid()
                .toolbar {
                    PhotoGalleryToolbarContent()
                }
        }
        .navigationSplitViewStyle(.prominentDetail)
        .environmentObject(navigationWrapper)
    }
}
