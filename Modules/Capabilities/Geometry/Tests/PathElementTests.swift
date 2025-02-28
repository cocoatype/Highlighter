//  Created by Geoff Pado on 2/25/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import CoreGraphics
import Testing

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
@testable import GeometryMac
#elseif canImport(UIKit)
@testable import Geometry
#endif

struct PathElementTests {
    @Test(arguments: [
        ([], CGPathElementType.closeSubpath),
        ([CGPoint(x: 10, y: 10)], .moveToPoint),
        ([CGPoint(x: 10, y: 10)], .addLineToPoint),
        ([CGPoint(x: 10, y: 10), CGPoint(x: 20, y: 20)], .addQuadCurveToPoint),
        ([CGPoint(x: 10, y: 10), CGPoint(x: 20, y: 20), CGPoint(x: 30, y: 30)], .addCurveToPoint),
        ([], CGPathElementType(rawValue: 999)),
    ])
    func construct(points: [CGPoint], type: CGPathElementType?) throws {
        let type = try #require(type)
        var cgPathElement = try points.withUnsafeBufferPointer { bufferPointer in
            let baseAddress = try #require(bufferPointer.baseAddress)
            let mutablePointer = UnsafeMutablePointer(mutating: baseAddress)
            return CGPathElement(
                type: type,
                points: mutablePointer
            )
        }

        let pathElement = PathElement(elementPointer: &cgPathElement)
        #expect(pathElement.points == points)
        #expect(pathElement.type == type)
    }
}
