//  Created by Geoff Pado on 11/9/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import CoreGraphics

/// Layout math for the Apple Pencil squeeze menu.
///
/// All coordinates are in the menu's own space: a square of side `outerDiameter`
/// whose center is the center of the arc. Items are laid out clockwise along the
/// arc, starting at the 3 o'clock position, and each item is rotated to follow it.
public enum PencilMenuGeometry {
    public static let outerDiameter: Double = 298
    public static let padding: Double = 8
    public static let itemDiameter: Double = 36
    public static let selectedItemScale: Double = 1.4

    public static var itemCount: Int { HighlighterTool.allCases.count }

    public static var outerCircumference: Double {
        Double.pi * outerDiameter
    }

    public static var menuSize: CGSize { CGSize(dimension: outerDiameter) }
    public static var itemSize: CGSize { CGSize(dimension: itemDiameter) }

    // MARK: Arc

    /// The stroke width of the background arc.
    public static var lineWidth: Double {
        itemDiameter + padding
    }

    /// The fraction of the full circle covered by the background arc (excluding its round caps).
    public static var maxTrim: Double {
        let itemLength = itemDiameter * itemCount
        let paddingLength = padding * itemCount
        let requiredLength = itemLength + paddingLength - lineWidth
        return requiredLength / outerCircumference
    }

    // MARK: Items

    /// The rotation, in radians, of the item at `index` around the menu's center.
    public static func angle(forItemAt index: Int) -> Double {
        let offset = (padding + itemDiameter) * index
        let offsetPercent = offset / outerCircumference
        return offsetPercent * (Double.pi * 2)
    }

    /// The transform of the item at `index`, relative to an item-sized frame centered in the menu.
    public static func itemTransform(at index: Int) -> CGAffineTransform {
        let translateTransform = CGAffineTransform(translationX: outerDiameter / 2, y: 0)
        let centerOffsetTransform = CGAffineTransform(translationX: itemDiameter / -2, y: itemDiameter / -2)
        let rotateTransform = CGAffineTransform(rotationAngle: angle(forItemAt: index))
        let centerResetTransform = CGAffineTransform(translationX: itemDiameter / 2, y: itemDiameter / 2)
        return translateTransform
            .concatenating(centerOffsetTransform)
            .concatenating(rotateTransform)
            .concatenating(centerResetTransform)
    }

    /// The transform from item-local coordinates to menu coordinates for the item at `index`.
    private static func itemToMenuTransform(at index: Int) -> CGAffineTransform {
        let inset = (outerDiameter - itemDiameter) / 2
        return itemTransform(at: index)
            .concatenating(CGAffineTransform(translationX: inset, y: inset))
    }

    /// The center of the item at `index`, in menu coordinates.
    public static func itemCenter(at index: Int) -> CGPoint {
        CGPoint(x: itemDiameter / 2, y: itemDiameter / 2)
            .applying(itemToMenuTransform(at: index))
    }

    /// The hit-testable outline of the item at `index`, in menu coordinates.
    public static func itemPath(at index: Int) -> CGPath {
        var transform = itemToMenuTransform(at: index)
        return CGPath(ellipseIn: CGRect(origin: .zero, size: itemSize), transform: &transform)
    }

    /// The index of the item containing `point` (in menu coordinates), if any.
    public static func itemIndex(at point: CGPoint) -> Int? {
        (0..<itemCount).first { itemPath(at: $0).contains(point) }
    }

    /// Converts a point from the menu's superview into menu coordinates, given where the menu is centered.
    public static func menuPoint(for point: CGPoint, menuCenter: CGPoint) -> CGPoint {
        CGPoint(
            x: point.x - (menuCenter.x - outerDiameter / 2),
            y: point.y - (menuCenter.y - outerDiameter / 2)
        )
    }
}
