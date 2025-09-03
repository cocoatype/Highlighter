//  Created by Geoff Pado on 10/16/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import SwiftUI

@objc public protocol LimitedLibraryPresenting {
    func presentLimitedLibrary()
}

extension UIResponder {
    public var limitedLibraryPresenter: LimitedLibraryPresenting? {
        if let presenter = (self as? LimitedLibraryPresenting) {
            return presenter
        }

        return next?.limitedLibraryPresenter
    }
}
