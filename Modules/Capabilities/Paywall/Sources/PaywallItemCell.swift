//  Created by Geoff Pado on 11/9/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import DesignSystem
import UIKit

struct PaywallItem: Hashable {
    let header: String
    let text: String
    let imageName: String

    static var all: [PaywallItem] {
        var items = [
            PaywallItem(header: Strings.PaywallView.autoRedactionsHeader, text: Strings.PaywallView.autoRedactionsText, imageName: "Seek"),
        ]
        #if !targetEnvironment(macCatalyst)
        items.append(PaywallItem(header: Strings.PaywallView.documentScanningHeader, text: Strings.PaywallView.documentScanningText, imageName: "Scanner"))
        #endif
        items.append(contentsOf: [
            PaywallItem(header: Strings.PaywallView.shortcutsHeader, text: Strings.PaywallView.shortcutsText, imageName: "Shortcuts"),
            PaywallItem(header: Strings.PaywallView.supportDevelopmentHeader, text: Strings.PaywallView.supportDevelopmentText, imageName: "Support"),
            PaywallItem(header: Strings.PaywallView.crossPlatformHeader, text: Strings.PaywallView.crossPlatformText, imageName: "Systems"),
        ])
        return items
    }
}

class PaywallItemCell: UICollectionViewCell {
    static let imageAspectRatio = 166.0 / 290.0

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .tableViewCellBackground
        contentView.layer.cornerRadius = 21
        contentView.layer.cornerCurve = .continuous
        contentView.clipsToBounds = true

        let textStack = UIStackView(arrangedSubviews: [headerLabel, textLabel])
        textStack.axis = .vertical
        textStack.alignment = .fill
        textStack.spacing = 8
        textStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(textStack)
        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            textStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            textStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            imageView.topAnchor.constraint(equalTo: textStack.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: Self.imageAspectRatio),
        ])
    }

    func configure(with item: PaywallItem) {
        headerLabel.text = item.header

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        textLabel.attributedText = NSAttributedString(string: item.text, attributes: [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.appFont(forTextStyle: Self.textStyle),
            .foregroundColor: UIColor.white,
        ])

        imageView.image = UIImage(named: item.imageName)
        accessibilityLabel = [item.header, item.text].joined(separator: ", ")
    }

    // MARK: Boilerplate

    static var textStyle: UIFont.TextStyle {
        #if targetEnvironment(macCatalyst)
        .body
        #else
        .footnote
        #endif
    }

    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    let textLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isAccessibilityElement = false
        return imageView
    }()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
