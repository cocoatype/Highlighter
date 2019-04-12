//  Created by Geoff Pado on 4/10/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

extension CGSize {
    static func * (size: CGSize, multiplier: CGFloat) -> CGSize {
        return CGSize(width: size.width * multiplier, height: size.height * multiplier)
    }
}
