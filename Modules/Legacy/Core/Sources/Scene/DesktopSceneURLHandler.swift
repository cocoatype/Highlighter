//  Created by Geoff Pado on 7/26/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import UIKit
import URLParsing
import UserActivities

struct DesktopSceneURLHandler {
    let parser = URLParser()

    @discardableResult @MainActor
    func handle(_ context: UIOpenURLContext) -> Bool {
        let result = parser.parse(context.url)
        switch result {
        case .image(let imageURL):
            let activity = LaunchActivity(imageURL)
            UIApplication.shared.requestSceneSessionActivation(nil, userActivity: activity, options: nil, errorHandler: nil)
            return true
        case .website(let webURL):
            UIApplication.shared.open(webURL)
            return false
        case .callbackAction, .invalid: return false
        }
    }
}
