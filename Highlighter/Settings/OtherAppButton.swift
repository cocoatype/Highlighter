//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct OtherAppButton: View {
    private let name: String
    private let id: String

    init(name: String, id: String) {
        self.name = name
        self.id = id
    }

    private var url: URL {
        let urlString = "https://apps.apple.com/us/app/cocoatype/id\(id)?uo=4"
        guard let url = URL(string: urlString) else { fatalError("Invalid App Store URL: \(urlString)") }
        return url
    }

    var body: some View {
        Button(name) {
            UIApplication.shared.open(url)
        }.settingsCell()
    }
}

struct OtherAppButton_Previews: PreviewProvider {
    static var previews: some View {
        OtherAppButton(name: "Kineo", id: "286948844").preferredColorScheme(.dark)
    }
}
