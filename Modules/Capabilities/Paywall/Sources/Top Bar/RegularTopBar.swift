//  Created by Geoff Pado on 1/19/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct RegularTopBar: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            TopBarHeadline()
            TopBarSubheadline()
        }
        .padding(40)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.primaryDark)
    }
}

#Preview {
    RegularTopBar()
}
