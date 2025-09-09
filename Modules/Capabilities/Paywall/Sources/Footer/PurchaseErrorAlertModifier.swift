//  Created by Geoff Pado on 7/9/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import SwiftUI

@available(iOS 16.0, *)
struct PurchaseErrorAlertModifier: ViewModifier {
    @Binding private var isPresented: Bool
    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
    }

    func body(content: Content) -> some View {
        content
            .alert(Strings.PurchaseErrorAlertModifier.errorTitle, isPresented: $isPresented) {
                Button(Strings.PurchaseErrorAlertModifier.dismissButton) {}
            } message: {
                Text(Strings.PurchaseErrorAlertModifier.errorMessage)
            }
    }
}

@available(iOS 16.0, *)
extension View {
    func errorAlert(isPresented: Binding<Bool>) -> some View {
        modifier(PurchaseErrorAlertModifier(isPresented: isPresented))
    }
}
