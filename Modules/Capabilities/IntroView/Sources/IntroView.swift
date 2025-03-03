//  Created by Geoff Pado on 4/1/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import DesignSystem
import SwiftUI

public struct IntroView: View {
    init(permissionAction: @escaping (() -> Void) = {}, importAction: @escaping (() -> Void) = {}) {
        self.permissionAction = permissionAction
        self.importAction = importAction
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            IntroLabel(Strings.permissionLabelText)
            IntroButton(Strings.permissionButtonTitle, action: permissionAction)

            IntroLabel(Strings.importLabelText).padding(.top, 12)
            IntroButton(Strings.importButtonTitle, action: importAction)
        }.background(Color.appPrimary).frame(maxWidth: 240)
    }

    // MARK: Boilerplate

    private let permissionAction: (() -> Void)
    private let importAction: (() -> Void)

    private typealias Strings = IntroViewStrings.IntroView
}
