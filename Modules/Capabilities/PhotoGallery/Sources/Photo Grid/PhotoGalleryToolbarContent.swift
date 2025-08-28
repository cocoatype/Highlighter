//  Created by Geoff Pado on 8/28/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import SwiftUI

import AppNavigation

@available(iOS 26.0, *)
struct PhotoGalleryToolbarContent: ToolbarContent {
    @EnvironmentObject private var navigationWrapper: NavigationWrapper

    var body: some ToolbarContent {
        ToolbarItem {
            Button {
                navigationWrapper.presentDocumentScanner()
            } label: {
                Image(systemName: "doc.text.viewfinder")
            }
        }

        ToolbarItem {
            Button {
                navigationWrapper.presentLimitedLibrary()
            } label: {
                Image(systemName: "rectangle.stack.badge.plus")
            }
        }

#if compiler(>=6.2)
        ToolbarSpacer(.fixed)
#endif

        ToolbarItem {
            Button {
                navigationWrapper.presentSettings()
            } label: {
                Image(systemName: "gear")
            }
        }
    }
}
