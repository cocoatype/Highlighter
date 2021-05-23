//  Created by Geoff Pado on 8/17/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation

class PurchaseOperationQueue: OperationQueue {
    override init() {
        super.init()
        qualityOfService = .userInitiated
    }
}
