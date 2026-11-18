//  Created by Geoff Pado on 10/16/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import UIKit

@MainActor
@objc public protocol LimitedLibraryPresenting {
    func presentLimitedLibrary()
}

extension UIResponder {
    public var limitedLibraryPresenter: any LimitedLibraryPresenting? {
        if let presenter = (self as? any LimitedLibraryPresenting) {
            return presenter
        }

        return next?.limitedLibraryPresenter
    }
}
