//  Created by Geoff Pado on 8/30/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct AlbumsSectionHeader: View {
    private let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .textCase(nil)
            .font(Font.app(textStyle: .title3))
            .foregroundColor(.white)
    }
}
