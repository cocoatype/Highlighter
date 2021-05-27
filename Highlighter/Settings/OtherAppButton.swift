//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct OtherAppButton: View {
    private let name: String
    private let subtitle: String
    private let id: String

    init(name: String, subtitle: String, id: String) {
        self.name = name
        self.subtitle = subtitle
        self.id = id
    }

    private var url: URL {
        let urlString = "https://apps.apple.com/us/app/cocoatype/id\(id)?uo=4"
        guard let url = URL(string: urlString) else { fatalError("Invalid App Store URL: \(urlString)") }
        return url
    }

    var body: some View {
        Button(action: {
            UIApplication.shared.open(url)
        }, label: {
            HStack {
                Image(decorative: name).cornerRadius(5.6)
                VStack(alignment: .leading) {
                    OtherAppNameText(name)
                    OtherAppSubtitleText(subtitle)
                }
            }
        }).settingsCell()
    }
}

struct OtherAppNameText: View {
    private let text: String
    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text).font(.app(textStyle: .subheadline)).foregroundColor(.white)
    }
}

struct OtherAppSubtitleText: View {
    private let text: String
    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text).font(.app(textStyle: .footnote)).foregroundColor(.primaryExtraLight)
    }
}

struct OtherAppButton_Previews: PreviewProvider {
    static var previews: some View {
        OtherAppButton(name: "Kineo", subtitle: "Create flipbook-style animations", id: "286948844").preferredColorScheme(.dark)
    }
}
