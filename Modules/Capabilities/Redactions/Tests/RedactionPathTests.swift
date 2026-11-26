//  Created by Geoff Pado on 11/25/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

#if canImport(UIKit)
import Testing
import UIKit

@testable import Redactions

struct RedactionPathTests {
    @Test func copiesDrawingProperties() {
        let source = Self.sampleBezierPath()
        let path = RedactionPath(source)

        #expect(path.elements == [
            .move(to: CGPoint(x: 10, y: 10)),
            .line(to: CGPoint(x: 15, y: 12)),
            .quadCurve(to: CGPoint(x: 25, y: 14), control: CGPoint(x: 20, y: 14)),
            .line(to: CGPoint(x: 50, y: 16)),
        ])
        #expect(path.cgPath == source.cgPath)
        #expect(path.lineWidth == 20)
        #expect(path.lineCapStyle == .round)
        #expect(path.lineJoinStyle == .bevel)
        #expect(path.miterLimit == 4)
        #expect(path.flatness == 0.5)
        #expect(path.usesEvenOddFillRule)
        #expect(path.currentPoint == CGPoint(x: 50, y: 16))
    }

    @Test func mutatingSourceDoesNotChangePath() {
        let source = Self.sampleBezierPath()
        let path = RedactionPath(source)
        let originalCGPath = path.cgPath.copy()

        source.addLine(to: CGPoint(x: 100, y: 100))
        source.lineWidth = 1
        source.lineCapStyle = .butt

        #expect(path.cgPath == originalCGPath)
        #expect(path.lineWidth == 20)
        #expect(path.lineCapStyle == .round)
    }

    @Test func bezierPathRestoresDrawingProperties() {
        let source = Self.sampleBezierPath()
        let bezierPath = RedactionPath(source).bezierPath

        #expect(bezierPath.cgPath == source.cgPath)
        #expect(bezierPath.lineWidth == source.lineWidth)
        #expect(bezierPath.lineCapStyle == source.lineCapStyle)
        #expect(bezierPath.lineJoinStyle == source.lineJoinStyle)
        #expect(bezierPath.miterLimit == source.miterLimit)
        #expect(bezierPath.flatness == source.flatness)
        #expect(bezierPath.usesEvenOddFillRule == source.usesEvenOddFillRule)
    }

    @Test func mutatingBezierPathDoesNotChangePath() {
        let path = RedactionPath(Self.sampleBezierPath())
        let originalCGPath = path.cgPath.copy()

        let bezierPath = path.bezierPath
        bezierPath.addLine(to: CGPoint(x: 100, y: 100))
        bezierPath.lineWidth = 1

        #expect(path.cgPath == originalCGPath)
        #expect(path.lineWidth == 20)
        #expect(path.bezierPath !== bezierPath)
    }

    @Test func redactionPathsAreSeparateInstances() throws {
        let redaction = Redaction(path: Self.sampleBezierPath(), color: .black)
        let first = try #require(redaction.paths.first)
        first.lineWidth = 1

        #expect(redaction.paths.first !== first)
        #expect(redaction.paths.first?.lineWidth == 20)
    }

    private static func sampleBezierPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 10, y: 10))
        path.addLine(to: CGPoint(x: 15, y: 12))
        path.addQuadCurve(to: CGPoint(x: 25, y: 14), controlPoint: CGPoint(x: 20, y: 14))
        path.addLine(to: CGPoint(x: 50, y: 16))
        path.lineWidth = 20
        path.lineCapStyle = .round
        path.lineJoinStyle = .bevel
        path.miterLimit = 4
        path.flatness = 0.5
        path.usesEvenOddFillRule = true
        return path
    }
}
#endif
