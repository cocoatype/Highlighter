//  Created by Geoff Pado on 7/16/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Redactions
import UIKit

public enum Route {
    case documentScanner
    case editor(UIImage, [Redaction])
}
