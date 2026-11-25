//  Created by Geoff Pado on 11/25/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import FactoryKit

public extension Container {
    var textDetector: Factory<any TextDetecting> {
        Factory(self) { TextDetector() }
    }
}
