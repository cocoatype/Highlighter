//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct SettingsHeaderTextCaseModifier: ViewModifier {
    func body(content: Content) -> some View {
        AnyView(content).textCase(nil)
    }
}

extension View {
    func settingsHeaderTextCase() -> ModifiedContent<Self, SettingsHeaderTextCaseModifier> {
        modifier(SettingsHeaderTextCaseModifier())
    }
}
