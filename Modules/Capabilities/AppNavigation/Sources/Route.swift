//  Created by Geoff Pado on 7/16/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Redactions
import UIKit

public enum Route {
    #if targetEnvironment(macCatalyst)
    case editor(URL)
    #else
    case documentScanner
    case paywall
    case editor(UIImage, [Redaction])
    #endif
}
