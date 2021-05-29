//  Created by Geoff Pado on 5/28/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import UIKit

@available(iOS 14.0, *)
class LimitedLibraryPhotoLibraryViewCell: UICollectionViewCell {
    static let identifier = "LimitedLibraryPhotoLibraryViewCell.identifier"

    override init(frame: CGRect) {
        iconView = DocumentScannerPhotoLibraryViewCellIconView()
        super.init(frame: frame)

        contentView.addSubview(iconView)
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            iconView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            iconView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        isAccessibilityElement = true
        accessibilityLabel = Self.defaultAccessibilityLabel
        backgroundColor = .primary
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        UIColor.primaryLight.setStroke()

        let borderRect = bounds.insetBy(dx: 8.5, dy: 8.5)
        let borderPath = UIBezierPath(roundedRect: borderRect, cornerRadius: 8.0)
        borderPath.setLineDash([4, 2], count: 2, phase: 0)
        borderPath.stroke()
    }

    // MARK: Boilerplate

    private static let defaultAccessibilityLabel = NSLocalizedString("LimitedLibraryPhotoLibraryViewCell.defaultAccessibilityLabel", comment: "Accessibility label for the document scanner cell")

    private let iconView: DocumentScannerPhotoLibraryViewCellIconView

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }

}
