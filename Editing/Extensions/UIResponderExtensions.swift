//  Created by Geoff Pado on 8/27/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import UIKit

extension UIResponder {
    public func chain(selector: Selector, object: Any? = nil, ignoreSelf: Bool = true) {
        let object = object ?? self
        let base = ignoreSelf ? next : self
        let actionTarget = base?.target(forAction: selector, withSender: self) as? UIResponder
        actionTarget?.perform(selector, with: object)
    }
}
