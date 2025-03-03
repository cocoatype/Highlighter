//  Created by Geoff Pado on 4/25/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import SwiftUI

public struct IntroButton: View {
    private let action: (() -> Void)
    private let title: String
    public init(_ title: String, action: @escaping (() -> Void)) {
        self.action = action
        self.title = title
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(.app(textStyle: .headline))
                .foregroundColor(.white)
                .underline()
        }
    }
}
