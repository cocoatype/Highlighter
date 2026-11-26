//  Created by Geoff Pado on 7/25/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Foundation

public enum URLParseResult {
    case callbackAction(CallbackAction)
    case image(URL)
    case website(URL)
    case invalid
}
