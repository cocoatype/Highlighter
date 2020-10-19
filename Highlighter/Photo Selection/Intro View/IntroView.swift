//  Created by Geoff Pado on 4/1/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import SwiftUI
import UIKit

struct IntroView: View {
    init(permissionAction: @escaping (() -> Void) = {}, importAction: @escaping (() -> Void) = {}) {
        self.permissionAction = permissionAction
        self.importAction = importAction
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            IntroLabel("IntroView.permissionLabelText")
            IntroButton("IntroView.permissionButtonTitle", action: permissionAction)
            if #available(iOS 14.0, *) {
                IntroLabel("IntroView.importLabelText").padding(.top, 12)
                IntroButton("IntroView.importButtonTitle", action: importAction)
            }
        }.background(Color.appPrimary).frame(maxWidth: 240)
    }

    // MARK: Boilerplate

    private let permissionAction: (() -> Void)
    private let importAction: (() -> Void)
}
