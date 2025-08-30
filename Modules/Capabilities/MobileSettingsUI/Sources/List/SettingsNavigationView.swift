//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import DesignSystem
import SwiftUI

struct SettingsNavigationView<Content: View>: View {
    private var content: () -> Content
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        NavigationView(content: content)
            .appNavigationBarAppearance()
            .navigationViewStyle(.stack)
    }
}

enum SettingsNavigationViewPreviews: PreviewProvider {
    static var previews: some View {
        SettingsNavigationView {}
            .preferredColorScheme(.dark)
    }
}
