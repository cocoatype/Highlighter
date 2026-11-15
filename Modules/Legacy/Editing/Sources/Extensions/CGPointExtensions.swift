//  Created by Geoff Pado on 7/31/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import UIKit

extension CGPoint {
    @MainActor func converted(from: UICoordinateSpace, to: UICoordinateSpace) -> CGPoint {
        from.convert(self, to: to)
    }
}
