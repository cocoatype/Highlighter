//  Created by Geoff Pado on 5/13/23.
//  Copyright © 2023 Cocoatype, LLC. All rights reserved.

import XCTest

@testable import Editing

final class BrushStampFactoryTests: XCTestCase {
    private let regularShape = Shape(bottomLeft: CGPoint(x: 0, y: 100), bottomRight: CGPoint(x: 100, y: 100), topLeft: CGPoint(x: 0, y: 0), topRight: CGPoint(x: 100, y: 0))
    private let verticallyFlippedShape = Shape(bottomLeft: CGPoint(x: 0, y: 0), bottomRight: CGPoint(x: 100, y: 0), topLeft: CGPoint(x: 0, y: 100), topRight: CGPoint(x: 100, y: 100))
    private let horizontallyFlippedShape = Shape(bottomLeft: CGPoint(x: 100, y: 100), bottomRight: CGPoint(x: 0, y: 100), topLeft: CGPoint(x: 100, y: 0), topRight: CGPoint(x: 0, y: 0))
    private let doublyFlippedShape = Shape(bottomLeft: CGPoint(x: 100, y: 0), bottomRight: CGPoint(x: 0, y: 0), topLeft: CGPoint(x: 100, y: 100), topRight: CGPoint(x: 0, y: 100))

    func testBrushImages() throws {
        _ = try BrushStampFactory.brushImages(for: regularShape, color: .black, scale: 1)
        _ = try BrushStampFactory.brushImages(for: regularShape, color: .black, scale: 2)
        _ = try BrushStampFactory.brushImages(for: regularShape, color: .black, scale: 3)
        _ = try BrushStampFactory.brushImages(for: regularShape, color: .black, scale: 0)

        _ = try BrushStampFactory.brushImages(for: verticallyFlippedShape, color: .black, scale: 1)
        _ = try BrushStampFactory.brushImages(for: verticallyFlippedShape, color: .black, scale: 2)
        _ = try BrushStampFactory.brushImages(for: verticallyFlippedShape, color: .black, scale: 3)
        _ = try BrushStampFactory.brushImages(for: verticallyFlippedShape, color: .black, scale: 0)

        _ = try BrushStampFactory.brushImages(for: horizontallyFlippedShape, color: .black, scale: 1)
        _ = try BrushStampFactory.brushImages(for: horizontallyFlippedShape, color: .black, scale: 2)
        _ = try BrushStampFactory.brushImages(for: horizontallyFlippedShape, color: .black, scale: 3)
        _ = try BrushStampFactory.brushImages(for: horizontallyFlippedShape, color: .black, scale: 0)

        _ = try BrushStampFactory.brushImages(for: doublyFlippedShape, color: .black, scale: 1)
        _ = try BrushStampFactory.brushImages(for: doublyFlippedShape, color: .black, scale: 2)
        _ = try BrushStampFactory.brushImages(for: doublyFlippedShape, color: .black, scale: 3)
        _ = try BrushStampFactory.brushImages(for: doublyFlippedShape, color: .black, scale: 0)
    }
}
