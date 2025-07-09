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
            .alert(Strings.errorTitle, isPresented: $isPresented) {
                Button(Strings.dismissButton) {}
            } message: {
                Text(Strings.errorMessage)
            }
    }

    private typealias Strings = PaywallStrings.PurchaseErrorAlertModifier
}

@available(iOS 16.0, *)
extension View {
    func errorAlert(isPresented: Binding<Bool>) -> some View {
        modifier(PurchaseErrorAlertModifier(isPresented: isPresented))
    }
}
