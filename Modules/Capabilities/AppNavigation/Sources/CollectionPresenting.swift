//  Created by Geoff Pado on 10/2/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import AlbumsData
import UIKit

@MainActor public protocol PhotoCollectionPresenting {
    func present(_ collection: PhotoCollection)
}

extension UIResponder {
    public var collectionPresenter: PhotoCollectionPresenting? {
        if let presenter = (self as? PhotoCollectionPresenting) {
            return presenter
        }

        return next?.collectionPresenter
    }
}
