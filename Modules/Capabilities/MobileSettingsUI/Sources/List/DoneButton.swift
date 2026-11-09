//  Created by Geoff Pado on 6/29/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct DoneButton: View {
    private let action: (() -> Void)
    init(action: @escaping (() -> Void)) {
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark")
        }
        .foregroundColor(.white)
        .font(Font.navigationBarButtonFont)
        .accessibilityLabel(Strings.DoneButton.label)
    }
}
