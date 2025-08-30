//  Created by Geoff Pado on 2/25/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import CoreGraphics
import Testing

@testable import Geometry

struct CGPointExtensionsTests {
    @Test func multiplyByFloat() {
        #expect(CGPoint(x: 1, y: 2) * 2.5 == CGPoint(x: 2.5, y: 5))
    }

    @Test func addSize() {
        let point = CGPoint(x: 1, y: 2)
        let size = CGSize(width: 3, height: 4)
        #expect(point + size == CGPoint(x: 4, y: 6))
    }

    @Test func distance() {
        let firstPoint = CGPoint(x: 0, y: 0)
        let secondPoint = CGPoint(x: 2, y: 2)
        let expectedValue = sqrt(8)
        #expect(abs(firstPoint.distance(to: secondPoint) - expectedValue) < 0.01)
    }

    @Test func hashIsStableWhenValuesAreStable() {
        let firstPoint = CGPoint(x: 0, y: 0)
        let secondPoint = CGPoint(x: 0, y: 0)
        var firstHasher = Hasher()
        firstHasher.combine(firstPoint)
        let firstHash = firstHasher.finalize()
        var secondHasher = Hasher()
        secondHasher.combine(secondPoint)
        let secondHash = secondHasher.finalize()
        #expect(firstHash == secondHash)
    }

    @Test func hashChangesWhenValuesChange() {
        let firstPoint = CGPoint(x: 0, y: 0)
        let secondPoint = CGPoint(x: 2, y: 2)
        var firstHasher = Hasher()
        firstHasher.combine(firstPoint)
        let firstHash = firstHasher.finalize()
        var secondHasher = Hasher()
        secondHasher.combine(secondPoint)
        let secondHash = secondHasher.finalize()
        #expect(firstHash != secondHash)
    }
}
