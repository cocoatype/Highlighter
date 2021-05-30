//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct SettingsList<Content>: View where Content: View {
    private let content: (() -> Content)
    init(@ViewBuilder content: @escaping (() -> Content)) {
        self.content = content
    }

    var body: some View {
        List(content: content)
            .settingsListStyle()
            .introspectTableView { $0.backgroundColor = .primary }
    }
}

struct SettingsListPreviews: PreviewProvider {
    static var previews: some View {
        SettingsList() {}.preferredColorScheme(.dark)
    }
}
