//  Created by Geoff Pado on 6/14/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Redactions
import UIKit

@MainActor public protocol Navigator: Sendable {
    func navigate(to route: Route)
}

public enum Route {
    case documentScanner
    case editor(UIImage, [Redaction])
}
