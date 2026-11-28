//  Created by Geoff Pado on 11/27/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import CoreGraphics

import FactoryKit

public extension Container {
    // CGPath's set operations need iOS 16. Before that, this falls back to
    // `legacyIntersectionFinder`, which Editing registers with its ClippingBezier finder.
    var intersectionFinder: Factory<any IntersectionFinder> {
        Factory(self) {
            if #available(iOS 16.0, macOS 13.0, *) {
                SystemIntersectionFinder()
            } else {
                self.legacyIntersectionFinder()
            }
        }
    }

    var legacyIntersectionFinder: Factory<any IntersectionFinder> {
        Factory(self) { NoIntersectionFinder() }
    }
}

private struct NoIntersectionFinder: IntersectionFinder {
    func intersectionExists(between lhs: CGPath, and rhs: CGPath) -> Bool { false }
}
