//  Created by Geoff Pado on 6/29/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct CloseButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        #if targetEnvironment(macCatalyst)
        EmptyView()
        #else
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.app(textStyle: .headline))
                .foregroundColor(.white)
                .padding(20)
        }
        #endif
    }
}
