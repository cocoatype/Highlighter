//  Created by Geoff Pado on 5/16/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Intents

extension RedactDetectedIntentResponseCode {
    #if targetEnvironment(macCatalyst)
    static let unpurchased = RedactDetectedIntentResponseCode.unpurchasedDesktop
    #else
    static let unpurchased = RedactDetectedIntentResponseCode.unpurchasedMobile
    #endif
}
