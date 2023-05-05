//  Created by Geoff Pado on 8/30/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct AlbumsRowSelectedViewModifier: ViewModifier {
    private let isSelected: Bool
    init(isSelected: Bool) {
        self.isSelected = isSelected
    }
    func body(content: Content) -> some View {
        if isSelected {
            AnyView(content).listRowBackground(Color.primaryDark.clipShape(RoundedRectangle(cornerRadius: 8)))
        } else {
            content
        }
    }
}

extension View {
    func selected(_ isSelected: Bool) -> ModifiedContent<Self, AlbumsRowSelectedViewModifier> {
        modifier(AlbumsRowSelectedViewModifier(isSelected: isSelected))
    }
}
