//  Created by Geoff Pado on 5/16/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Intents

extension RedactDetectedIntentResponse {
    static func success(_ redactedImages: [INFile]) -> RedactDetectedIntentResponse {
        let response = RedactDetectedIntentResponse(code: .success, userActivity: nil)
        response.redactedImages = redactedImages
        return response
    }
    static var failure = RedactDetectedIntentResponse(code: .failure, userActivity: nil)
    static let unpurchased = RedactDetectedIntentResponse(code: .unpurchased, userActivity: nil)
}
