//  Created by Geoff Pado on 11/9/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import UIKit

/// The row of restore / terms / privacy links at the bottom of the paywall.
///
/// Like SwiftUI's `ViewThatFits`, it tries each layout in `FooterLinkRowView.layouts`
/// in order and displays the first one whose natural width fits in its bounds.
class FooterLinkRowView: UIView {
    struct Layout: Equatable {
        let axis: NSLayoutConstraint.Axis
        let usesShortRestoreTitle: Bool
        let usesShortTermsTitle: Bool
        let usesShortPrivacyTitle: Bool
    }

    enum Link: CaseIterable {
        case restore
        case terms
        case privacy
    }

    static let layouts: [Layout] = [NSLayoutConstraint.Axis.horizontal, .vertical].flatMap { axis in
        [
            // Restore Purchases — Terms & Conditions — Privacy Policy
            Layout(axis: axis, usesShortRestoreTitle: false, usesShortTermsTitle: false, usesShortPrivacyTitle: false),
            // Restore — Terms & Conditions — Privacy Policy
            Layout(axis: axis, usesShortRestoreTitle: true, usesShortTermsTitle: false, usesShortPrivacyTitle: false),
            // Restore — Terms & Conditions — Privacy
            Layout(axis: axis, usesShortRestoreTitle: true, usesShortTermsTitle: false, usesShortPrivacyTitle: true),
            // Restore — Terms — Privacy
            Layout(axis: axis, usesShortRestoreTitle: true, usesShortTermsTitle: true, usesShortPrivacyTitle: true),
        ]
    }

    var linkHandler: ((Link) -> Void)?

    private(set) var currentLayout: Layout?

    init() {
        super.init(frame: .zero)
        candidateViews = Self.layouts.map(makeStackView(for:))
        show(Self.layouts[0])
    }

    // MARK: Layout Selection

    override func layoutSubviews() {
        selectLayout(forWidth: bounds.width)
        super.layoutSubviews()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
            lastSelectionWidth = nil
            setNeedsLayout()
        }
    }

    func selectLayout(forWidth width: CGFloat) {
        guard width > 0, width != lastSelectionWidth else { return }
        lastSelectionWidth = width

        let fittingIndex = candidateViews.firstIndex { candidate in
            candidate.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width <= width
        }
        show(Self.layouts[fittingIndex ?? Self.layouts.index(before: Self.layouts.endIndex)])
    }

    private func show(_ layout: Layout) {
        guard layout != currentLayout,
              let index = Self.layouts.firstIndex(of: layout)
        else { return }
        currentLayout = layout

        displayedView?.removeFromSuperview()
        let stackView = candidateViews[index]
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
        ])
        displayedView = stackView
        superview?.setNeedsLayout()
    }

    // MARK: Views

    private func makeStackView(for layout: Layout) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [
            makeButton(for: .restore, usesShortTitle: layout.usesShortRestoreTitle),
            makeSeparator(),
            makeButton(for: .terms, usesShortTitle: layout.usesShortTermsTitle),
            makeSeparator(),
            makeButton(for: .privacy, usesShortTitle: layout.usesShortPrivacyTitle),
        ])
        stackView.axis = layout.axis
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

    private func makeButton(for link: Link, usesShortTitle: Bool) -> UIButton {
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = .zero
        configuration.title = Self.title(for: link, usesShortTitle: usesShortTitle)
        configuration.baseForegroundColor = .white
        configuration.titleAlignment = .center
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .appFont(forTextStyle: .footnote)
            return outgoing
        }

        let button = UIButton(configuration: configuration)
        button.addAction(UIAction { [weak self] _ in self?.linkHandler?(link) }, for: .primaryActionTriggered)
        return button
    }

    private func makeSeparator() -> UILabel {
        let label = UILabel()
        label.text = " — "
        label.font = .preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .white
        label.isAccessibilityElement = false
        return label
    }

    static func title(for link: Link, usesShortTitle: Bool) -> String {
        switch (link, usesShortTitle) {
        case (.restore, false): Strings.FooterRestoreLink.title
        case (.restore, true): Strings.FooterRestoreLink.shortTitle
        case (.terms, false): Strings.FooterTermsLink.title
        case (.terms, true): Strings.FooterTermsLink.shortTitle
        case (.privacy, false): Strings.FooterPrivacyLink.title
        case (.privacy, true): Strings.FooterPrivacyLink.shortTitle
        }
    }

    // MARK: Boilerplate

    private var candidateViews = [UIStackView]()
    private weak var displayedView: UIStackView?
    private var lastSelectionWidth: CGFloat?

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
