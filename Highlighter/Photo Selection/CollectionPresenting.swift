//  Created by Geoff Pado on 10/2/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import UIKit

protocol CollectionPresenting {
    func present(_ collection: Collection)
}

extension UIResponder {
    var collectionPresenter: CollectionPresenting? {
        if let presenter = (self as? CollectionPresenting) {
            return presenter
        }

        return next?.collectionPresenter
    }
}
