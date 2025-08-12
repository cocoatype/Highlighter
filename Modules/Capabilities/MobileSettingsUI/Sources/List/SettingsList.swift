//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct SettingsList<Content>: View where Content: View {
    private let content: (() -> Content)
    private let dismissAction: (() -> Void)
    private var viewController: UIViewController?
    init(dismissAction: @escaping (() -> Void), @ViewBuilder content: @escaping (() -> Content)) {
        self.content = content
        self.dismissAction = dismissAction
    }

    var body: some View {
        List(content: content)
            .settingsListStyle()
            .settingsListBackground()
            .navigationBarItems(trailing: DoneButton(action: dismissAction))
    }
}

enum SettingsListPreviews: PreviewProvider {
    static var previews: some View {
        SettingsList(dismissAction: {}, content: {})
            .preferredColorScheme(.dark)
    }
}
