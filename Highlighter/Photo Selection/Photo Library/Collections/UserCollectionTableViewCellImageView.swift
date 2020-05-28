//  Created by Geoff Pado on 5/27/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Editing
import UIKit

class UserCollectionTableViewCellImageView: UIImageView {
    init() {
        super.init(frame: .zero)
        accessibilityIgnoresInvertColors = true
        clipsToBounds = true
        contentMode = .scaleAspectFill
        translatesAutoresizingMaskIntoConstraints = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let maskLayer = CAShapeLayer()
        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 5.6).cgPath
        layer.mask = maskLayer
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
