//  Created by Geoff Pado on 7/1/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import AppNavigation
import Editing
import SwiftUI

struct DocumentScanButton: View {
    var body: some View {
        GeometryReader { proxy in
            Button { navigationWrapper.presentDocumentScanner()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8.0).strokeBorder(style: StrokeStyle(dash: [4, 2]), antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/).padding(8).foregroundColor(Color.primaryLight)
                    Image(systemName: "doc.text.viewfinder").resizable( resizingMode: /*@START_MENU_TOKEN@*/.stretch/*@END_MENU_TOKEN@*/).frame(width: proxy.size.width / 2.0, height: proxy.size.height / 2.0, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).foregroundColor(Color.primaryExtraLight)
                }
            }
        }
    }

    @EnvironmentObject private var navigationWrapper: NavigationWrapper
}

enum DocumentScanButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DocumentScanButton().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            DocumentScanButton().frame(width: 60, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
    }
}
