//  Created by Geoff Pado on 5/20/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import UIKit

class CollectionEvent: UIEvent {
    let collection: Collection

    init(_ collection: Collection) {
        self.collection = collection
        super.init()
    }
}
