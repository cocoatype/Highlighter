//  Created by Geoff Pado on 7/25/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import UIKit

public struct URLParser {
    public init() {}

    public func parse(_ url: URL) -> URLParseResult {
        if let action = CallbackAction(url: url) {
            return .callbackAction(action)
        } else if url.isFileURL {
            return .image(url)
        } else if let webURL = webURL(from: url) {
            return .website(webURL)
        } else {
            return .invalid
        }
    }

    func webURL(from url: URL) -> URL? {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              components.host == "blackhighlighter.app"
        else { return nil }

        components.scheme = "https"

        return components.url
    }
}
