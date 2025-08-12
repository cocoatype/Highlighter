//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct SettingsNavigationLink<Destination: View>: View {
    private let destination: Destination
    private let title: String
    init(_ title: String, destination: Destination) {
        self.title = title
        self.destination = destination
    }

    var body: some View {
        NavigationLink(title, destination: destination).settingsCell()
    }
}

enum SettingsNavigationLinkPreviews: PreviewProvider {
    static var previews: some View {
        SettingsNavigationLink("Hello, world!", destination: Text?.none).preferredColorScheme(.dark)
    }
}
