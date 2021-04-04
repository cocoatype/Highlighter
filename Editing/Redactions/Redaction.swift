//  Created by Geoff Pado on 5/6/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public struct Redaction: Equatable {
    public let color: NSColor
    public let paths: [NSBezierPath]
}
#elseif canImport(UIKit)
import UIKit

public struct Redaction: Equatable {
    public let color: UIColor
    public let paths: [UIBezierPath]
}
#endif
