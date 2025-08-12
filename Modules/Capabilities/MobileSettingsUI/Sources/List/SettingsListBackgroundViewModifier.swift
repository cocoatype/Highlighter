//  Created by Geoff Pado on 5/5/23.
//  Copyright © 2023 Cocoatype, LLC. All rights reserved.

import SwiftUI
import SwiftUIIntrospect

struct SettingsListBackgroundViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        backgroundColored(content)
            .introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18)) {
                $0.indicatorStyle = .white
            }
    }

    @ViewBuilder
    private func backgroundColored(_ content: Content) -> some View {
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
    func settingsListBackground() -> ModifiedContent<Self, SettingsListBackgroundViewModifier> {
        modifier(SettingsListBackgroundViewModifier())
    }
}
