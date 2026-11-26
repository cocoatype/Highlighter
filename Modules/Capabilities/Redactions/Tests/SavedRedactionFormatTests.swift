//  Created by Geoff Pado on 11/25/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

#if canImport(UIKit)
import Foundation
import Geometry
import Testing
import UIKit

@testable import Redactions

// The fixtures in TestResources were written by RedactionSerializer as of #589. They pin the saved format: if
// these tests fail, redactions that people have already saved will no longer restore. Don't regenerate the
// fixtures to make them pass; keep decoding the old bytes.
struct SavedRedactionFormatTests {
    @Test func shapeRedactionDecodes() throws {
        let data = try fixture(named: "ShapeRedaction")
        let redaction = try #require(RedactionSerializer.redaction(from: data))

        #expect(try components(of: redaction.color) == [0, 0, 0, 1])
        #expect(redaction.parts == [.shape(.savedWide), .shape(.savedNarrow)])
    }

    @Test func pathRedactionDecodes() throws {
        let data = try fixture(named: "PathRedaction")
        let redaction = try #require(RedactionSerializer.redaction(from: data))

        #expect(try components(of: redaction.color) == [1, 0.5, 0.25, 1])
        try #require(redaction.parts.count == 1)
        try expectSavedBrushStroke(redaction.parts[0])
    }

    @Test func legacyRedactionDecodes() throws {
        let data = try fixture(named: "LegacyRedaction")
        let pathsData = try PropertyListDecoder().decode([Data].self, from: data)
        let redaction = try #require(RedactionSerializer.redaction(fromLegacyData: pathsData))

        #expect(try components(of: redaction.color) == [0, 0, 0, 1])
        try #require(redaction.parts.count == 2)
        try expectSavedBrushStroke(redaction.parts[0])
        #expect(redaction.parts[1] == .shape(.savedWide))
    }

    @Test(arguments: ["ShapeRedaction", "PathRedaction"])
    func savedRedactionRoundTrips(fixtureName: String) throws {
        let data = try fixture(named: fixtureName)
        let redaction = try #require(RedactionSerializer.redaction(from: data))

        let reencoded = RedactionSerializer.dataRepresentation(of: redaction)
        let restored = try #require(RedactionSerializer.redaction(from: reencoded))

        #expect(restored == redaction)
    }

    @Test func pathRedactionRoundTripKeepsBrushStroke() throws {
        let data = try fixture(named: "PathRedaction")
        let redaction = try #require(RedactionSerializer.redaction(from: data))

        let reencoded = RedactionSerializer.dataRepresentation(of: redaction)
        let restored = try #require(RedactionSerializer.redaction(from: reencoded))

        try #require(restored.parts.count == 1)
        try expectSavedBrushStroke(restored.parts[0])
    }

    @Test func legacyRedactionRoundTripsThroughCurrentFormat() throws {
        let data = try fixture(named: "LegacyRedaction")
        let pathsData = try PropertyListDecoder().decode([Data].self, from: data)
        let redaction = try #require(RedactionSerializer.redaction(fromLegacyData: pathsData))

        let reencoded = RedactionSerializer.dataRepresentation(of: redaction)
        let restored = try #require(RedactionSerializer.redaction(from: reencoded))

        #expect(restored == redaction)
        try #require(restored.parts.count == 2)
        try expectSavedBrushStroke(restored.parts[0])
        #expect(restored.parts[1] == .shape(.savedWide))
    }

    // MARK: Helpers

    private func fixture(named name: String) throws -> Data {
        let url = try #require(Bundle.module.url(forResource: name, withExtension: "bplist"))
        return try Data(contentsOf: url)
    }

    private func components(of color: UIColor) throws -> [CGFloat] {
        var red = CGFloat.zero, green = CGFloat.zero, blue = CGFloat.zero, alpha = CGFloat.zero
        try #require(color.getRed(&red, green: &green, blue: &blue, alpha: &alpha))
        return [red, green, blue, alpha]
    }

    private func expectSavedBrushStroke(_ part: RedactionPart) throws {
        guard case .path(let path) = part else {
            Issue.record("Expected a path, got \(part)")
            return
        }

        let expected = UIBezierPath()
        expected.move(to: CGPoint(x: 10, y: 10))
        expected.addLine(to: CGPoint(x: 15, y: 12))
        expected.addQuadCurve(to: CGPoint(x: 25, y: 14), controlPoint: CGPoint(x: 20, y: 14))
        expected.addQuadCurve(to: CGPoint(x: 40, y: 15), controlPoint: CGPoint(x: 30, y: 14))
        expected.addLine(to: CGPoint(x: 50, y: 16))

        #expect(path.cgPath == expected.cgPath)
        #expect(path.lineWidth == 20)
        #expect(path.lineCapStyle == .butt)
        #expect(path.lineJoinStyle == .bevel)
        #expect(path.usesEvenOddFillRule)
    }
}

private extension Shape {
    static let savedWide = Shape(
        bottomLeft: CGPoint(x: 10, y: 40),
        bottomRight: CGPoint(x: 110, y: 40),
        topLeft: CGPoint(x: 10, y: 20),
        topRight: CGPoint(x: 110, y: 20)
    )

    static let savedNarrow = Shape(
        bottomLeft: CGPoint(x: 10, y: 70),
        bottomRight: CGPoint(x: 60, y: 70),
        topLeft: CGPoint(x: 10, y: 50),
        topRight: CGPoint(x: 60, y: 50)
    )
}
#endif
