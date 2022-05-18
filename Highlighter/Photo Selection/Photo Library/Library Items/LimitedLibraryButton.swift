//  Created by Geoff Pado on 10/16/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct LimitedLibraryButton: View {
    var body: some View {
        GeometryReader { proxy in
            Button(action: { navigationWrapper.presentLimitedLibrary() }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8.0).strokeBorder(style: StrokeStyle(dash: [4, 2]), antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/).padding(8).foregroundColor(Color.primaryLight)
                    Image(systemName: "rectangle.stack.badge.plus").resizable( resizingMode: /*@START_MENU_TOKEN@*/.stretch/*@END_MENU_TOKEN@*/).frame(width: proxy.size.width / 2.0, height: proxy.size.height / 2.0, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).foregroundColor(Color.primaryExtraLight)
                }
            }
        }
    }

    @EnvironmentObject private var navigationWrapper: NavigationWrapper
}

protocol LimitedLibraryPresenting {
    func presentLimitedLibrary()
}

extension UIResponder {
    var limitedLibraryPresenter: LimitedLibraryPresenting? {
        if let presenter = (self as? LimitedLibraryPresenting) {
            return presenter
        }

        return next?.limitedLibraryPresenter
    }
}
