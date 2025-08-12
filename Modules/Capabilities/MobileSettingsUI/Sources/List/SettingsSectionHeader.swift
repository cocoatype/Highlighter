//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct SettingsSectionHeader: View {
    private let title: String
    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Text(title)
            .font(.app(textStyle: .footnote))
            .foregroundColor(Color(.primaryExtraLight))
            .settingsHeaderTextCase()
    }
}

enum SettingsSectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        SettingsSectionHeader("Hello, world!").preferredColorScheme(.dark)
    }
}
