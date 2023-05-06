//  Created by Geoff Pado on 5/5/23.
//  Copyright © 2023 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct SettingsListBackgroundViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        backgroundColored(content)
            .introspectScrollView {
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
                .introspectTableView {
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
