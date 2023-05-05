//  Created by Geoff Pado on 4/22/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import CoreGraphics

public protocol TextObservation: Equatable {
    var bounds: Shape { get }
}

extension TextObservation {
    var path: CGPath { bounds.path }
}
