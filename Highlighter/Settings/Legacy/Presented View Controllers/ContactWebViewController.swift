//  Created by Geoff Pado on 5/11/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation

class ContactWebViewController: WebViewController {
    init?() {
        guard let contactURL = URL(string: "https://highlighter.cocoatype.com/contact") else { return nil }
        super.init(url: contactURL)
    }
}
