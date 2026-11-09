//  Created by Geoff Pado on 5/13/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import SwiftUI

public extension View {
    func fill() -> some View {
        return self.modifier(FillViewModifier())
    }
}

struct FillViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        AnyView(content).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
    }
}
