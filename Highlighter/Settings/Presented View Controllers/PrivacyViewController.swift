//  Created by Geoff Pado on 5/11/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation

class PrivacyViewController: WebViewController {
    init?() {
        guard let privacyURL = URL(string: "https://highlighter.cocoatype.com/privacy") else { return nil }
        super.init(url: privacyURL)
    }
}
