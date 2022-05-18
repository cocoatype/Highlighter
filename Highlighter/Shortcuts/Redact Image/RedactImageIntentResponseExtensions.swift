//  Created by Geoff Pado on 5/16/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Intents

extension RedactImageIntentResponse {
    static func success(_ redactedImages: [INFile]) -> RedactImageIntentResponse {
        let response = RedactImageIntentResponse(code: .success, userActivity: nil)
        response.redactedImages = redactedImages
        return response
    }
    static var failure = RedactImageIntentResponse(code: .failure, userActivity: nil)
    static let unpurchased = RedactImageIntentResponse(code: .unpurchased, userActivity: nil)
}
