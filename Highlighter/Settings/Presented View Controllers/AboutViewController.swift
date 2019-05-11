//  Created by Geoff Pado on 5/11/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation

class AboutViewController: WebViewController {
    init?() {
        guard let aboutURL = URL(string: "https://highlighter.cocoatype.com/about") else { return nil }
        super.init(url: aboutURL)
    }
}
