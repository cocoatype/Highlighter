//  Created by Geoff Pado on 11/9/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import DesignSystem
import UIKit

/// The paywall's top bar: a headline and subheadline on a dark band, with an optional close button.
///
/// Below `PaywallLayout.breakWidth` it uses the compact layout (40pt top and 20pt
/// other padding); at or above it, the regular layout (40pt padding all around).
class PaywallHeaderView: UICollectionReusableView {
    static let elementKind = "PaywallHeaderView.elementKind"

    var closeHandler: (() -> Void)?

    var showsCloseButton = true {
        didSet { closeButton.isHidden = !showsCloseButton }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .primaryDark

        let stackView = UIStackView(arrangedSubviews: [headlineLabel, subheadlineLabel])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        addSubview(closeButton)

        closeButton.addAction(UIAction { [weak self] _ in self?.closeHandler?() }, for: .primaryActionTriggered)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            closeButton.topAnchor.constraint(equalTo: topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        updateMargins(forWidth: frame.width)
    }

    // MARK: Layout

    static func margins(forWidth width: CGFloat) -> NSDirectionalEdgeInsets {
        if width < PaywallLayout.breakWidth {
            NSDirectionalEdgeInsets(top: 40, leading: 20, bottom: 20, trailing: 20)
        } else {
            NSDirectionalEdgeInsets(top: 40, leading: 40, bottom: 40, trailing: 40)
        }
    }

    private func updateMargins(forWidth width: CGFloat) {
        let margins = Self.margins(forWidth: width)
        if directionalLayoutMargins != margins {
            directionalLayoutMargins = margins
        }
    }

    override func layoutSubviews() {
        updateMargins(forWidth: bounds.width)
        super.layoutSubviews()
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        updateMargins(forWidth: layoutAttributes.size.width)
        return super.preferredLayoutAttributesFitting(layoutAttributes)
    }

    // MARK: Boilerplate

    let headlineLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.TopBarHeadline.text
        label.font = .appFont(forTextStyle: .largeTitle)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .white
        label.numberOfLines = 2
        label.accessibilityTraits = .header
        return label
    }()

    let subheadlineLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.TopBarSubheadline.text
        label.font = .appFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .primaryUltraLight
        label.numberOfLines = 0
        return label
    }()

    let closeButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "xmark")
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: .appFont(forTextStyle: .headline))
        configuration.baseForegroundColor = .white
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        let button = UIButton(configuration: configuration)
        button.accessibilityLabel = Strings.CloseButton.accessibilityLabel
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
