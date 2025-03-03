//  Created by Geoff Pado on 4/25/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import SwiftUI

public struct IntroLabel: View {
    private let text: String
    public init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        Text(text)
            .foregroundColor(.primaryExtraLight)
            .font(.app(textStyle: .body))
    }
}
