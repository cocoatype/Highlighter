//  Created by Geoff Pado on 5/26/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct ActionView: View {
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 8) {
                Spacer()
                Image("highlighter.magic").resizable(resizingMode: .stretch).frame(width: 52, height: 55, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Text("Loading…").font(.app(textStyle: .headline))
                Spacer()
            }
            Spacer()
        }.background(Color.appPrimary)
    }
}

struct ActionViewPreviews: PreviewProvider {
    static var previews: some View {
        ActionView().preferredColorScheme(.dark)
    }
}
