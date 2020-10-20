//  Created by Geoff Pado on 5/6/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

public protocol Redaction {
    var color: UIColor { get }
    var paths: [UIBezierPath] { get }
}
