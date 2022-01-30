//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct SettingsSectionHeader: View {
    private let titleKey: LocalizedStringKey
    init(_ titleKey: LocalizedStringKey) {
        self.titleKey = titleKey
    }

    var body: some View {
        Text(titleKey)
            .font(.app(textStyle: .footnote))
            .foregroundColor(Color(.primaryExtraLight))
            .settingsHeaderTextCase()
    }
}

struct SettingsSectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        SettingsSectionHeader("Hello, world!").preferredColorScheme(.dark)
    }
}
