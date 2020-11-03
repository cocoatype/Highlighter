//  Created by Geoff Pado on 5/6/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

#if canImport(AppKit)
import AppKit

public protocol Redaction {
    var color: NSColor { get }
    var paths: [NSBezierPath] { get }
}
#elseif canImport(UIKit)
import UIKit

public protocol Redaction {
    var color: UIColor { get }
    var paths: [UIBezierPath] { get }
}
#endif
