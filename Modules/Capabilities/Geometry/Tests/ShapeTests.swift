//  Created by Geoff Pado on 10/19/23.
//  Copyright © 2023 Cocoatype, LLC. All rights reserved.

import CoreGraphics
import Testing

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
@testable import GeometryMac
#elseif canImport(UIKit)
@testable import Geometry
#endif

struct ShapeTests {
    // MARK: - scaled

    @Test func scaled() {
        let shape = Shape(
            bottomLeft: CGPoint(x: 0.1, y: 0.2),
            bottomRight: CGPoint(x: 0.2, y: 0.2),
            topLeft: CGPoint(x: 0.1, y: 0.1),
            topRight: CGPoint(x: 0.2, y: 0.1)
        )
        let scaledShape = shape.scaled(to: CGSize(width: 100, height: 100))
        let expectedShape = Shape(
            bottomLeft: CGPoint(x: 10, y: 80),
            bottomRight: CGPoint(x: 20, y: 80),
            topLeft: CGPoint(x: 10, y: 90),
            topRight: CGPoint(x: 20, y: 90)
        )
        #expect(scaledShape == expectedShape)
    }

    // MARK: - boundingBox

    @Test func boundingBox() {
        let shape = Shape(
            bottomLeft: CGPoint(x: 3, y: 5),
            bottomRight: CGPoint(x: 5, y: 3),
            topLeft: CGPoint(x: 0, y: 2),
            topRight: CGPoint(x: 3, y: 0)
        )
        let expectedRect = CGRect(origin: .zero, size: CGSize(width: 5, height: 5))
        #expect(shape.boundingBox == expectedRect)
    }

    // MARK: - centerLeft

    @Test func centerLeft() {
        let shape = Shape(
            bottomLeft: CGPoint(x: 5, y: 10),
            bottomRight: CGPoint(x: 10, y: 10),
            topLeft: CGPoint(x: 5, y: 5),
            topRight: CGPoint(x: 10, y: 5)
        )
        #expect(shape.centerLeft == CGPoint(x: 5, y: 7.5))
    }

    // MARK: - centerRight

    @Test func centerRight() {
        let shape = Shape(
            bottomLeft: CGPoint(x: 5, y: 10),
            bottomRight: CGPoint(x: 10, y: 10),
            topLeft: CGPoint(x: 5, y: 5),
            topRight: CGPoint(x: 10, y: 5)
        )
        #expect(shape.centerRight == CGPoint(x: 10, y: 7.5))
    }

    // MARK: - angle

    @Test func angle() {
        let shape = Shape(
            bottomLeft: CGPoint(x: 5, y: 10),
            bottomRight: CGPoint(x: 10, y: 10),
            topLeft: CGPoint(x: 5, y: 5),
            topRight: CGPoint(x: 10, y: 5)
        )
        #expect(shape.angle == 0)
    }

    // MARK: - center

    @Test func center() {
        let shape = Shape(
            bottomLeft: CGPoint(x: 5, y: 10),
            bottomRight: CGPoint(x: 10, y: 10),
            topLeft: CGPoint(x: 5, y: 5),
            topRight: CGPoint(x: 10, y: 5)
        )
        #expect(shape.center == CGPoint(x: 7.5, y: 7.5))
    }

    // MARK: - path
    @Test func path() {
        let shape = Shape(
            bottomLeft: CGPoint(x: 0, y: 5),
            bottomRight: CGPoint(x: 5, y: 5),
            topLeft: CGPoint(x: 0, y: 0),
            topRight: CGPoint(x: 5, y: 0)
        )
        let expectedPath = CGMutablePath()
        expectedPath.move(to: CGPoint(x: 0, y: 0))
        expectedPath.addLine(to: CGPoint(x: 0, y: 5))
        expectedPath.addLine(to: CGPoint(x: 5, y: 5))
        expectedPath.addLine(to: CGPoint(x: 5, y: 0))
        expectedPath.closeSubpath()

        #expect(shape.path.isEqual(to: expectedPath, accuracy: 0.01))
    }

    // MARK: - centerLeft

    // MARK: - centerRight

    // MARK: - angle

    // MARK: - center

    // MARK: - ggImage

    @Test func normalizedShape() {
        let originalShape = Shape(
            bottomLeft: CGPoint(x: 946.7962608595813, y: 1331.9914845573883),
            bottomRight: CGPoint(x: 269.4029737073748, y: 1349.2245818822003),
            topLeft: CGPoint(x: 948.5000076543305, y: 1398.961839335604),
            topRight: CGPoint(x: 271.10672050212395, y: 1416.194936660416)
        )

        let expectedShape = Shape(
            bottomLeft: originalShape.topRight,
            bottomRight: originalShape.topLeft,
            topLeft: originalShape.bottomRight,
            topRight: originalShape.bottomLeft
        )

        #expect(originalShape.ggImage == expectedShape)
    }

    // MARK: - unionDotShapeDotShapeDotUnionCrash

    @Test func rectForIllDefinedShape() {
        let shape = Shape(
            bottomLeft: CGPoint(x: 980.34822556083, y: 1495.0016611479539),
            bottomRight: CGPoint(x: 265.68262147954465, y: 1491.5924762993577),
            topLeft: CGPoint(x: 979.9312930237021, y: 1582.403006848055),
            topRight: CGPoint(x: 265.26568894241666, y: 1578.9938219994588)
        )

        let expectedRect = CGRect(
            x: 265.68262147954465,
            y: 1491.5924762993577,
            width: 714.6737354892795,
            height: 87.40234014561102
        )
        let expectedAngle = 0.004770285528940842

        let rotatedResult = shape.unionDotShapeDotShapeDotUnionCrash
        let rotatedRect = rotatedResult.geometryStreamer
        let rotatedAngle = rotatedResult.thisGuyHeadBang
        #expect(abs(expectedRect.minX - rotatedRect.minX) < 0.01)
        #expect(abs(expectedRect.maxX - rotatedRect.maxX) < 0.01)
        #expect(abs(expectedRect.minY - rotatedRect.minY) < 0.01)
        #expect(abs(expectedRect.maxY - rotatedRect.maxY) < 0.01)
        #expect(abs(expectedAngle - rotatedAngle) < 0.01)
    }

    // MARK: - isNotZero

    @Test func zeroShapeIsNotNotZero() {
        let zeroShape = Shape.zero
        #expect(zeroShape.isNotZero == false)
    }

    @Test func emptyShapeIsNotZero() {
        let emptyShape = Shape(
            bottomLeft: CGPoint(x: 5, y: 5),
            bottomRight: CGPoint(x: 5, y: 5),
            topLeft: CGPoint(x: 5, y: 5),
            topRight: CGPoint(x: 5, y: 5)
        )
        #expect(emptyShape.isNotZero)
    }

    // MARK: - isNotEmpty

    @Test func isNotEmptyReturnsFalseForEmptyShape() {
        let emptyShape = Shape(
            bottomLeft: CGPoint(x: 5, y: 5),
            bottomRight: CGPoint(x: 5, y: 5),
            topLeft: CGPoint(x: 5, y: 5),
            topRight: CGPoint(x: 5, y: 5)
        )

        #expect(emptyShape.isNotEmpty == false)
    }

    @Test func isNotEmptyReturnsTrueForNonEmptyShape() {
        let shape = Shape(
            bottomLeft: CGPoint(x: 0, y: 5),
            bottomRight: CGPoint(x: 5, y: 5),
            topLeft: CGPoint(x: 0, y: 0),
            topRight: CGPoint(x: 5, y: 0)
        )

        #expect(shape.isNotEmpty == true)
    }

    // MARK: - integral

    @Test func integral() {
        let shape = Shape(
            bottomLeft: CGPoint(x: 0.5, y: 0.5),
            bottomRight: CGPoint(x: 1.5, y: 0.5),
            topLeft: CGPoint(x: 0.5, y: 1.5),
            topRight: CGPoint(x: 1.5, y: 1.5)
        )
        let expectedShape = Shape(
            bottomLeft: CGPoint(x: 0, y: 1),
            bottomRight: CGPoint(x: 2, y: 1),
            topLeft: CGPoint(x: 0, y: 1),
            topRight: CGPoint(x: 2, y: 1)
        )

        #expect(shape.integral == expectedShape)
    }
}
