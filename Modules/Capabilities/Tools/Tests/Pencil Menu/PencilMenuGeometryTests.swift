//  Created by Geoff Pado on 11/9/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import CoreGraphics
import Foundation
import Testing

@testable import Tools

struct PencilMenuGeometryTests {
    private static let menuCenter = CGPoint(x: 149, y: 149)
    private static let indices = Array(0..<PencilMenuGeometry.itemCount)

    private func distance(_ lhs: CGPoint, _ rhs: CGPoint) -> Double {
        hypot(lhs.x - rhs.x, lhs.y - rhs.y)
    }

    @Test func firstItemIsAtThreeOClock() {
        let center = PencilMenuGeometry.itemCenter(at: 0)
        #expect(abs(center.x - 298) < 0.001)
        #expect(abs(center.y - 149) < 0.001)
    }

    @Test(arguments: indices)
    func itemsLieOnTheArc(index: Int) {
        let center = PencilMenuGeometry.itemCenter(at: index)
        #expect(abs(distance(center, Self.menuCenter) - 149) < 0.001)
    }

    @Test(arguments: indices)
    func itemsAreSpacedByDiameterPlusPadding(index: Int) {
        let expectedAngle = Double(index) * (36 + 8) / (Double.pi * 298) * (Double.pi * 2)
        #expect(abs(PencilMenuGeometry.angle(forItemAt: index) - expectedAngle) < 0.0001)

        // items go clockwise, i.e. downward in UIKit coordinates
        let center = PencilMenuGeometry.itemCenter(at: index)
        let expected = CGPoint(x: 149 + 149 * cos(expectedAngle), y: 149 + 149 * sin(expectedAngle))
        #expect(distance(center, expected) < 0.001)
    }

    @Test func maxTrimCoversFirstToLastItemCenter() {
        let lastAngle = PencilMenuGeometry.angle(forItemAt: PencilMenuGeometry.itemCount - 1)
        #expect(abs(PencilMenuGeometry.maxTrim - lastAngle / (Double.pi * 2)) < 0.0001)
        #expect(PencilMenuGeometry.lineWidth == 44)
    }

    @Test(arguments: indices)
    func hitTestingItemCenter(index: Int) {
        #expect(PencilMenuGeometry.itemIndex(at: PencilMenuGeometry.itemCenter(at: index)) == index)
    }

    @Test(arguments: indices)
    func hitTestingJustInsideAndOutsideItem(index: Int) {
        let angle = PencilMenuGeometry.angle(forItemAt: index)
        let center = PencilMenuGeometry.itemCenter(at: index)

        let inside = CGPoint(x: center.x + 17 * cos(angle), y: center.y + 17 * sin(angle))
        #expect(PencilMenuGeometry.itemIndex(at: inside) == index)

        let outside = CGPoint(x: center.x + 19 * cos(angle), y: center.y + 19 * sin(angle))
        #expect(PencilMenuGeometry.itemIndex(at: outside) == nil)
    }

    @Test func hitTestingMenuCenterFindsNothing() {
        #expect(PencilMenuGeometry.itemIndex(at: Self.menuCenter) == nil)
    }

    @Test func menuPointConversion() {
        let point = PencilMenuGeometry.menuPoint(for: CGPoint(x: 500, y: 400), menuCenter: CGPoint(x: 400, y: 300))
        #expect(point == CGPoint(x: 249, y: 249))
    }
}
