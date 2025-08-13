//  Created by Geoff Pado on 7/4/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct TitleText: View {
    private let text: String
    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.app(textStyle: .subheadline))
            .foregroundColor(.white)
    }
}
