//  Created by Geoff Pado on 11/9/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import DesignSystem
import UIKit

/// The paywall footer, pinned to the bottom of the paywall outside of its scrolling content.
///
/// Its background extends under the bottom safe area; its contents stay inside it.
class PaywallFooterView: UIView {
    var retryHandler: (() -> Void)?
    var purchaseHandler: (() -> Void)?
    var optionSelectionHandler: ((PaywallOption) -> Void)?

    var linkHandler: ((FooterLinkRowView.Link) -> Void)? {
        get { linkRowView.linkHandler }
        set { linkRowView.linkHandler = newValue }
    }

    init() {
        super.init(frame: .zero)
        backgroundColor = .primary
        translatesAutoresizingMaskIntoConstraints = false
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        insetsLayoutMarginsFromSafeArea = true

        let purchaseStack = UIStackView(arrangedSubviews: [descriptionLabel, purchaseButton])
        purchaseStack.axis = .vertical
        purchaseStack.spacing = 8

        contentStack.addArrangedSubview(durationPicker)
        contentStack.addArrangedSubview(purchaseStack)
        contentStack.addArrangedSubview(linkRowView)

        errorStack.addArrangedSubview(errorLabel)
        errorStack.addArrangedSubview(retryButton)

        for view in [contentStack, errorStack, loadingIndicator] {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }

        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            errorStack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            errorStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            errorStack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            loadingIndicator.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])

        // only the visible content's bottom constraint is active, so it alone determines the footer's height
        bottomConstraints = [
            ObjectIdentifier(contentStack): contentStack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            ObjectIdentifier(errorStack): errorStack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            ObjectIdentifier(loadingIndicator): loadingIndicator.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
        ]
        setVisibleContent(loadingIndicator)

        durationPicker.addAction(UIAction { [weak self] _ in self?.durationPickerChanged() }, for: .valueChanged)
        retryButton.addAction(UIAction { [weak self] _ in self?.retryHandler?() }, for: .primaryActionTriggered)
        purchaseButton.addAction(UIAction { [weak self] _ in self?.purchaseHandler?() }, for: .primaryActionTriggered)
    }

    // MARK: Rendering

    func render(_ viewModel: PaywallViewModel) {
        switch viewModel.loadState {
        case .loading:
            setVisibleContent(loadingIndicator)
            loadingIndicator.startAnimating()
        case .failed:
            setVisibleContent(errorStack)
            loadingIndicator.stopAnimating()
        case .loaded:
            setVisibleContent(contentStack)
            loadingIndicator.stopAnimating()
        }

        let pickerOptions = viewModel.pickerOptions
        if pickerOptions != self.pickerOptions {
            self.pickerOptions = pickerOptions
            durationPicker.removeAllSegments()
            for (index, option) in pickerOptions.enumerated() {
                durationPicker.insertSegment(withTitle: PaywallViewModel.shortName(for: option), at: index, animated: false)
            }
        }
        durationPicker.selectedSegmentIndex = viewModel.selectedOption
            .flatMap { pickerOptions.firstIndex(of: $0) } ?? UISegmentedControl.noSegment

        descriptionLabel.text = viewModel.selectedOptionDescription
        descriptionLabel.isHidden = viewModel.selectedOptionDescription == nil

        purchaseButton.configuration?.title = viewModel.purchaseButtonTitle
        purchaseButton.configuration?.showsActivityIndicator = viewModel.isPurchasing
        purchaseButton.isEnabled = viewModel.isPurchaseButtonEnabled
    }

    private func setVisibleContent(_ visibleView: UIView) {
        for view in [contentStack, errorStack, loadingIndicator] as [UIView] {
            let isVisible = view === visibleView
            view.isHidden = !isVisible
            bottomConstraints[ObjectIdentifier(view)]?.isActive = isVisible
        }
    }

    private func durationPickerChanged() {
        let index = durationPicker.selectedSegmentIndex
        guard pickerOptions.indices.contains(index) else { return }
        optionSelectionHandler?(pickerOptions[index])
    }

    override func layoutSubviews() {
        linkRowView.selectLayout(forWidth: layoutMarginsGuide.layoutFrame.width)
        super.layoutSubviews()
    }

    // MARK: Boilerplate

    private var pickerOptions = [PaywallOption]()
    private var bottomConstraints = [ObjectIdentifier: NSLayoutConstraint]()

    let contentStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()

    let durationPicker: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.accessibilityLabel = Strings.DurationPicker.label
        segmentedControl.backgroundColor = .primary
        segmentedControl.selectedSegmentTintColor = .primaryLight
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.white,
            .font: UIFont.appFont(forTextStyle: .caption1),
        ], for: .normal)
        return segmentedControl
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    let purchaseButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .primaryLight
        configuration.baseForegroundColor = .white
        configuration.background.cornerRadius = 8
        configuration.cornerStyle = .fixed
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .appFont(forTextStyle: .headline)
            return outgoing
        }

        let button = UIButton(configuration: configuration)
        button.configurationUpdateHandler = { button in
            // keep the primaryLight background when disabled, dimming the title instead
            button.configuration?.background.backgroundColor = .primaryLight
            button.configuration?.baseForegroundColor = button.isEnabled ? .white : UIColor.white.withAlphaComponent(0.5)
        }
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        return button
    }()

    let linkRowView = FooterLinkRowView()

    let errorStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()

    let errorLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.PaywallLoadError.message
        label.font = .appFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    let retryButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.title = Strings.PaywallLoadError.retryButton
        configuration.baseForegroundColor = .white
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .appFont(forTextStyle: .headline)
            return outgoing
        }
        return UIButton(configuration: configuration)
    }()

    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.hidesWhenStopped = false
        return indicator
    }()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
