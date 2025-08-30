//  Created by Geoff Pado on 2/25/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import CoreGraphics
import Testing

@testable import Geometry

struct CGPathExtensionsTests {
    @Test
    func isEqual() {
        let rect = CGRect(origin: .zero, size: CGSize(width: 10, height: 10))
        let rectPath = CGPath(rect: rect, transform: nil)
        let manualPath = CGMutablePath()
        manualPath.move(to: CGPoint(x: rect.minX, y: rect.minY))
        manualPath.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        manualPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        manualPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        manualPath.closeSubpath()

        #expect(rectPath.isEqual(to: manualPath, accuracy: 0.01))
    }

    @Test
    func isEqualReturnsFalseIfElementTypesDiffer() {
        let rect = CGRect(origin: .zero, size: CGSize(width: 10, height: 10))
        let rectPath = CGPath(rect: rect, transform: nil)
        let manualPath = CGMutablePath()
        manualPath.move(to: CGPoint(x: rect.minX, y: rect.minY))
        manualPath.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        manualPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        manualPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        manualPath.addLine(to: CGPoint(x: rect.minX, y: rect.minY))

        #expect(rectPath.isEqual(to: manualPath, accuracy: 0.01) == false)
    }

    @Test
    func forEachPoint() async {
        let rect = CGRect(origin: .zero, size: CGSize(width: 10, height: 10))
        let path = CGPath(rect: rect, transform: nil)

        await confirmation(expectedCount: 4) { pointCalled in
            path.forEachPoint { _ in
                pointCalled()
            }
        }
    }

    @Test
    func area() {
        let rect = CGRect(origin: .zero, size: CGSize(width: 10, height: 10))
        let path = CGPath(rect: rect, transform: nil)
        #expect(path.area() == 100)
    }
}
