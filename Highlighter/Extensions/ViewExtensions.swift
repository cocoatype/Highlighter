//  Created by Geoff Pado on 5/30/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Combine
import SwiftUI

extension View {
    public func onAppReceive<P>(_ publisher: P, perform action: @escaping (P.Output) -> Void) -> some View where P : Publisher, P.Failure == Never {
        let isPreview: Bool
        #if DEBUG
            isPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        #else
            isPreview = false
        #endif

        if isPreview {
            return self.onReceive(publisher, perform: { _ in })
        } else {
            return self.onReceive(publisher, perform: action)
        }
    }

    public func fill() -> some View {
        return self.modifier(FillViewModifier())
    }
}

struct FillViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        AnyView(content).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
    }
}
