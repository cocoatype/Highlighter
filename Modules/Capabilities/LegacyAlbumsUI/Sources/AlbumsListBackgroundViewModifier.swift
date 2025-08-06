//  Created by Geoff Pado on 7/8/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import SwiftUI
import SwiftUIIntrospect

struct AlbumsListBackgroundViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16, *) {
            content
                .scrollContentBackground(.hidden)
                .background(Color.appPrimary)
        } else {
            content
                .introspect(.list, on: .iOS(.v13, .v14, .v15)) {
                    $0.backgroundColor = .primary
                }
        }
    }
}

extension View {
    func albumsListBackground() -> ModifiedContent<Self, AlbumsListBackgroundViewModifier> {
        modifier(AlbumsListBackgroundViewModifier())
    }
}
