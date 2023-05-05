//  Created by Geoff Pado on 8/18/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

extension UnsafePointer {
    var optional: Optional<UnsafePointer<Pointee>> {
        get { return Optional(self) }
        set(newOptional) { if let newSelf = newOptional { self = newSelf} }
    }
}
