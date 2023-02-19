//  Created by Geoff Pado on 5/15/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

extension Redaction {
    init(path: UIBezierPath, color: UIColor) {
        self.init(color: color, parts: [.path(path)])
    }
}
