//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct SettingsNavigationLink<Destination: View>: View {
    private let destination: Destination
    private let titleKey: LocalizedStringKey
    init(_ titleKey: LocalizedStringKey, destination: Destination) {
        self.titleKey = titleKey
        self.destination = destination
    }

    var body: some View {
        NavigationLink(titleKey, destination: destination).settingsCell()
    }
}

struct SettingsNavigationLinkPreviews: PreviewProvider {
    static var previews: some View {
        SettingsNavigationLink("Hello, world!", destination: Text?.none).preferredColorScheme(.dark)
    }
}
