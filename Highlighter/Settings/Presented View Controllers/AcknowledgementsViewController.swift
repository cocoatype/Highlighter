//  Created by Geoff Pado on 5/11/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation

class AcknowledgementsViewController: WebViewController {
    static var url: URL {
        guard let privacyURL = URL(string: "https://highlighter.cocoatype.com/acknowledgements") else { fatalError("Invalid URL for privacy policy") }
        return privacyURL
    }

    init?() {
        super.init(url: Self.url)
    }
}
