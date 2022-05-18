//  Created by Geoff Pado on 5/16/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Intents

extension RedactImageIntentResponseCode {
    #if targetEnvironment(macCatalyst)
    static let unpurchased = RedactImageIntentResponseCode.unpurchasedDesktop
    #else
    static let unpurchased = RedactImageIntentResponseCode.unpurchasedMobile
    #endif
}
