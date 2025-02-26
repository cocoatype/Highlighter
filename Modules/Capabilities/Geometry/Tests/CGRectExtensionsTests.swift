//  Created by Geoff Pado on 2/25/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import CoreGraphics
import Testing

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
@testable import GeometryMac
#elseif canImport(UIKit)
@testable import Geometry
#endif

struct CGRectExtensionsTests {
    @Test func multiplyByFloat() {
        #expect(CGRect(x: 1, y: 2, width: 10, height: 20) * 2.5 == CGRect(x: 2.5, y: 5, width: 25, height: 50))
    }

    @Test func createFromTwoPoints() {
        let actualRect = CGRect(.zero, CGPoint(x: 5, y: 5))
        let expectedRect = CGRect(origin: .zero, size: CGSize(width: 5, height: 5))
        #expect(actualRect == expectedRect)
    }

    @Test func center() {
        let rect = CGRect(origin: .zero, size: CGSize(width: 10, height: 10))
        #expect(rect.center == CGPoint(x: 5, y: 5))
    }

    @Test func fittingWider() {
        let smallRect = CGRect(origin: .zero, size: CGSize(width: 5, height: 5))
        let largeRect = CGRect(origin: .zero, size: CGSize(width: 50, height: 10))
        let expectedRect = CGRect(x: 20, y: 0, width: 10, height: 10)
        #expect(smallRect.fitting(rect: largeRect) == expectedRect)
    }

    @Test func fittingTaller() {
        let smallRect = CGRect(origin: .zero, size: CGSize(width: 5, height: 5))
        let largeRect = CGRect(origin: .zero, size: CGSize(width: 10, height: 50))
        let expectedRect = CGRect(x: 0, y: 20, width: 10, height: 10)
        #expect(smallRect.fitting(rect: largeRect) == expectedRect)
    }

    @Test func fittingEqual() {
        let smallRect = CGRect(origin: .zero, size: CGSize(width: 5, height: 5))
        let largeRect = CGRect(origin: .zero, size: CGSize(width: 50, height: 50))
        let expectedRect = largeRect
        #expect(smallRect.fitting(rect: largeRect) == expectedRect)
    }

    @Test func flippedRect() {
        let rect = CGRect(x: 0.1, y: 0.1, width: 0.5, height: 0.5)
        let size = CGSize(width: 100, height: 100)
        #if canImport(UIKit)
        let expectedRect = CGRect(x: 10, y: 40, width: 50, height: 50)
        #else
        let expectedRect = CGRect(x: 10, y: 10, width: 50, height: 50)
        #endif
        #expect(CGRect.flippedRect(from: rect, scaledTo: size) == expectedRect)
    }
}
