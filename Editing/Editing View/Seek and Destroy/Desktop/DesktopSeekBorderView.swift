//  Created by Geoff Pado on 12/20/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import ErrorHandling
import UIKit

class DesktopSeekBorderView: UIView {
    init(style: DesktopSeekBox.Style) {
        self.cornerRadius = style.cornerRadius
        super.init(frame: .zero)
        backgroundColor = .clear
        isOpaque = false
        translatesAutoresizingMaskIntoConstraints = false
    }

    override func willMove(toWindow window: UIWindow?) {
        #if targetEnvironment(macCatalyst)
        let screenScale = window?.screen.scale ?? UIScreen.main.scale
        layer.addSublayer(InnerBorderLayer(cornerRadius: cornerRadius, screenScale: screenScale))
        layer.addSublayer(OuterBorderLayer(cornerRadius: cornerRadius, screenScale: screenScale))
        #endif
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)

        layer.sublayers?.forEach{ sublayer in
            sublayer.frame = layer.bounds
        }
    }

    #warning("Remember to fix light mode colors!")

    class InnerBorderLayer: CALayer {
        init(cornerRadius: CGFloat, screenScale: CGFloat) {
            super.init()
            self.cornerRadius = cornerRadius
            self.borderWidth = 1
            self.borderColor = UIColor.seekBoxInnerBorder?.cgColor
        }

        override init(layer: Any) {
            super.init(layer: layer)
        }

        @available(*, unavailable)
        required init(coder: NSCoder) {
            let typeName = NSStringFromClass(type(of: self))
            fatalError("\(typeName) does not implement init(coder:)")
        }
    }

    class OuterBorderLayer: CALayer {
        init(cornerRadius: CGFloat, screenScale: CGFloat) {
            super.init()
            self.cornerRadius = cornerRadius
            self.borderWidth = 1.0 / screenScale
            self.borderColor = UIColor.seekBoxOuterBorder?.cgColor
        }

        override init(layer: Any) {
            super.init(layer: layer)
        }

        @available(*, unavailable)
        required init(coder: NSCoder) {
            let typeName = NSStringFromClass(type(of: self))
            fatalError("\(typeName) does not implement init(coder:)")
        }
    }

    // MARK: Boilerplate

    private let cornerRadius: CGFloat

    @available(*, unavailable)
    required init(coder: NSCoder) {
        ErrorHandling.notImplemented()
    }
}
