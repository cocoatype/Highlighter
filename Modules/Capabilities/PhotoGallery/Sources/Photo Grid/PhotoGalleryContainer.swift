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
                    ToolbarItem {
                        Button {} label: {
                            Image(systemName: "doc.text.viewfinder")
                        }
                    }
                    ToolbarItem {
                        Button {} label: {
                            Image(systemName: "rectangle.stack.badge.plus")
                        }
                    }
#if compiler(>=6.2)
                    ToolbarSpacer(.fixed)
#endif
                    ToolbarItem {
                        Button {} label: {
                            Image(systemName: "gear")
                        }
                    }
                }
        }
        .navigationSplitViewStyle(.prominentDetail)
        .environmentObject(navigationWrapper)
    }
}
