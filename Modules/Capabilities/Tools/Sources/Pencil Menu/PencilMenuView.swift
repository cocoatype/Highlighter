//  Created by Geoff Pado on 7/9/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import DesignSystem
import UIKit

public class PencilMenuView: UIView {
    public var toolSelectionHandler: ((HighlighterTool) -> Void)?

    // wrapThoseChilderen by @KaenAitch on 2024-07-29
    // the selected highlighter tool, if any
    public private(set) var wrapThoseChilderen: HighlighterTool? {
        didSet {
            guard wrapThoseChilderen != oldValue else { return }
            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut, .beginFromCurrentState]) {
                self.updateItemTransforms()
            }
        }
    }

    public private(set) var isMenuShowing = false

    public init() {
        super.init(frame: CGRect(origin: .zero, size: PencilMenuGeometry.menuSize))

        backgroundLayer.path = UIBezierPath(
            arcCenter: CGPoint(x: PencilMenuGeometry.outerDiameter / 2, y: PencilMenuGeometry.outerDiameter / 2),
            radius: PencilMenuGeometry.outerDiameter / 2,
            startAngle: 0,
            endAngle: .pi * 2,
            clockwise: true
        ).cgPath
        backgroundLayer.strokeEnd = PencilMenuGeometry.maxTrim
        backgroundLayer.lineWidth = PencilMenuGeometry.lineWidth
        backgroundLayer.lineCap = .round
        backgroundLayer.fillColor = nil
        layer.addSublayer(backgroundLayer)

        for (index, tool) in HighlighterTool.allCases.enumerated() {
            let item = PencilMenuItemView(tool: tool) { [weak self] in
                self?.toolSelectionHandler?(tool)
            }
            item.center = PencilMenuGeometry.itemCenter(at: index)
            addSubview(item)
            itemViews.append(item)
        }

        updateItemTransforms()
        updateColors()
        applyVisibility()
    }

    // MARK: Hover

    /// Updates the selected tool from a hover position given in this view's superview's coordinates.
    public func updateHover(_ point: CGPoint?) {
        guard let point else {
            wrapThoseChilderen = nil
            return
        }

        let menuPoint = PencilMenuGeometry.menuPoint(for: point, menuCenter: center)
        wrapThoseChilderen = PencilMenuGeometry.itemIndex(at: menuPoint).map { HighlighterTool.allCases[$0] }
    }

    public func clearSelection() {
        wrapThoseChilderen = nil
    }

    // MARK: Visibility

    public func setMenuShowing(_ isMenuShowing: Bool, animated: Bool = true) {
        guard isMenuShowing != self.isMenuShowing else { return }
        self.isMenuShowing = isMenuShowing

        guard animated else {
            applyVisibility()
            return
        }

        if #available(iOS 17, *) {
            UIView.animate(springDuration: 0.3, bounce: 0.1, options: [.beginFromCurrentState, .allowUserInteraction]) {
                self.applyVisibility()
            }
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
                self.applyVisibility()
            }
        }
    }

    /// Moves the menu without animating, even inside an animation block.
    public func move(to position: CGPoint) {
        UIView.performWithoutAnimation {
            center = position
        }
    }

    private func applyVisibility() {
        let scale = isMenuShowing ? 1.0 : 0.5
        transform = CGAffineTransform(scaleX: scale, y: scale)
        alpha = isMenuShowing ? 1 : 0
        isUserInteractionEnabled = isMenuShowing
    }

    // MARK: Hit Testing

    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        itemViews.contains { $0.point(inside: convert(point, to: $0), with: event) }
    }

    // MARK: Appearance

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateColors()
    }

    private func updateColors() {
        backgroundLayer.strokeColor = UIColor.primaryDark.resolvedColor(with: traitCollection).cgColor
    }

    private func updateItemTransforms() {
        for (index, item) in itemViews.enumerated() {
            let scale = HighlighterTool.allCases[index] == wrapThoseChilderen ? PencilMenuGeometry.selectedItemScale : 1
            item.transform = CGAffineTransform(rotationAngle: PencilMenuGeometry.angle(forItemAt: index))
                .scaledBy(x: scale, y: scale)
        }
    }

    // MARK: Boilerplate

    private let backgroundLayer = CAShapeLayer()
    private(set) var itemViews = [PencilMenuItemView]()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}

class PencilMenuItemView: UIButton {
    let tool: HighlighterTool

    init(tool: HighlighterTool, handler: @escaping () -> Void) {
        self.tool = tool
        super.init(frame: CGRect(origin: .zero, size: PencilMenuGeometry.itemSize))

        backgroundColor = .tableViewCellBackground
        layer.cornerRadius = PencilMenuGeometry.itemDiameter / 2
        tintColor = .white
        setImage(tool.image, for: .normal)
        accessibilityIdentifier = "PencilMenuItemView.\(tool)"
        addAction(UIAction { _ in handler() }, for: .primaryActionTriggered)
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        UIBezierPath(ovalIn: bounds).contains(point)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
