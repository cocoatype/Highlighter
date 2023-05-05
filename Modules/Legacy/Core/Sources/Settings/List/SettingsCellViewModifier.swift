//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Introspect
import SwiftUI

struct SettingsCellViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        AnyView(content)
            .font(.app(textStyle: .subheadline))
            .foregroundColor(.white)
            .listRowBackground(Color(.tableViewCellBackground))
            .introspectTableViewCell { cell in
                cell.selectedBackgroundView = {
                    let view = UIView()
                    view.backgroundColor = .tableViewCellBackgroundHighlighted
                    return view
                }()
            }
    }
}

extension View {
    func settingsCell() -> ModifiedContent<Self, SettingsCellViewModifier> {
        modifier(SettingsCellViewModifier())
    }
}
