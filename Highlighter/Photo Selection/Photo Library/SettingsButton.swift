//  Created by Geoff Pado on 8/12/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct SettingsButton: View {
    @EnvironmentObject var navigationWrapper: NavigationWrapper

    var body: some View {
        return Button(action: {
            navigationWrapper.presentSettings()
        }) {
            Image(systemName: "gear").foregroundColor(.white)
        }
    }
}

struct SettingsButton_Previews: PreviewProvider {
    static var previews: some View {
        SettingsButton()
            .preferredColorScheme(.dark)
    }
}
