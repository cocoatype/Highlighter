//  Created by Geoff Pado on 11/9/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import UIKit

import FactoryKit

import DesignSystem
import Logging

/// Layout values shared by the paywall's views.
enum PaywallLayout {
    /// At or above this width, the paywall uses its regular layout with two columns of items.
    static let breakWidth = CGFloat(640)

    static func columnCount(forWidth width: CGFloat) -> Int {
        width < breakWidth ? 1 : 2
    }
}

@available(iOS 16.0, *)
public class PaywallViewController: UIViewController, UICollectionViewDelegate {

    /// Called after a purchase (or restore) completes.
    public var purchaseCompletionHandler: (() -> Void)?

    /// - Parameter isModal: whether the paywall is presented modally (and so shows its own close
    ///   button), or pushed onto a navigation stack (and so relies on the back button).
    public init(isModal: Bool = true) {
        self.isModal = isModal
        self.viewModel = PaywallViewModel()
        super.init(nibName: nil, bundle: nil)
    }

    init(isModal: Bool, viewModel: PaywallViewModel) {
        self.isModal = isModal
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primary

        let topBand = UIView()
        topBand.backgroundColor = .primaryDark
        topBand.translatesAutoresizingMaskIntoConstraints = false

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBand)
        view.addSubview(collectionView)
        view.addSubview(footerView)

        NSLayoutConstraint.activate([
            topBand.topAnchor.constraint(equalTo: view.topAnchor),
            topBand.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBand.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBand.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),

            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        configureDataSource()
        bindViewModel()

        loadTask = Task { [weak self] in
            await self?.viewModel.load()
        }
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard hasLoggedAppearance == false else { return }
        hasLoggedAppearance = true
        logger.log(Event(name: .purchaseMarketingDisplayed))
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // keep the scrolling content clear of the footer (the collection view already insets for the safe area)
        let footerInset = max(0, footerView.frame.height - view.safeAreaInsets.bottom)
        if collectionView.contentInset.bottom != footerInset {
            collectionView.contentInset.bottom = footerInset
            collectionView.verticalScrollIndicatorInsets.bottom = footerInset
        }
    }

    deinit {
        loadTask?.cancel()
    }

    // MARK: View Model

    private func bindViewModel() {
        viewModel.onChange = { [weak self] in
            self?.render()
        }
        viewModel.onPurchaseError = { [weak self] in
            self?.presentAlert(
                title: Strings.PurchaseErrorAlertModifier.errorTitle,
                message: Strings.PurchaseErrorAlertModifier.errorMessage
            )
        }
        viewModel.onRestoreError = { [weak self] in
            self?.presentAlert(
                title: Strings.RestoreErrorAlert.errorTitle,
                message: Strings.RestoreErrorAlert.errorMessage
            )
        }
        viewModel.onPurchaseCompleted = { [weak self] in
            self?.purchaseCompletionHandler?()
        }

        footerView.retryHandler = { [weak self] in
            Task { await self?.viewModel.loadProducts() }
        }
        footerView.purchaseHandler = { [weak self] in
            Task { await self?.viewModel.purchase() }
        }
        footerView.optionSelectionHandler = { [weak self] option in
            self?.viewModel.selectedOption = option
        }
        footerView.linkHandler = { [weak self] link in
            self?.handle(link)
        }

        render()
    }

    private func render() {
        footerView.render(viewModel)
        view.setNeedsLayout()
    }

    private func handle(_ link: FooterLinkRowView.Link) {
        switch link {
        case .restore:
            Task { await viewModel.restore() }
        case .terms:
            UIApplication.shared.open(PaywallViewModel.termsURL)
        case .privacy:
            UIApplication.shared.open(PaywallViewModel.privacyURL)
        }
    }

    private func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.PurchaseErrorAlertModifier.dismissButton, style: .default))
        present(alert, animated: true)
    }

    // MARK: Collection View

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<PaywallItemCell, PaywallItem> { cell, _, item in
            cell.configure(with: item)
        }

        let headerRegistration = UICollectionView.SupplementaryRegistration<PaywallHeaderView>(
            elementKind: PaywallHeaderView.elementKind
        ) { [weak self] header, _, _ in
            header.showsCloseButton = self?.showsCloseButton ?? false
            header.closeHandler = { [weak self] in
                self?.dismiss(animated: true)
            }
        }

        dataSource = UICollectionViewDiffableDataSource<Int, PaywallItem>(collectionView: collectionView) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        dataSource?.supplementaryViewProvider = { collectionView, _, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }

        var snapshot = NSDiffableDataSourceSnapshot<Int, PaywallItem>()
        snapshot.appendSections([0])
        snapshot.appendItems(PaywallItem.all)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }

    private static var layout: UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, environment in
            let columnCount = PaywallLayout.columnCount(forWidth: environment.container.effectiveContentSize.width)
            let estimatedHeight = NSCollectionLayoutDimension.estimated(320)

            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1 / CGFloat(columnCount)),
                heightDimension: estimatedHeight
            ))
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: estimatedHeight),
                repeatingSubitem: item,
                count: columnCount
            )
            group.interItemSpacing = .fixed(20)

            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(160)),
                elementKind: PaywallHeaderView.elementKind,
                alignment: .top
            )

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 20
            section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 20, bottom: 24, trailing: 20)
            section.supplementariesFollowContentInsets = false
            section.boundarySupplementaryItems = [header]

            // the feature grid sits on the primary color, even where the dark top band is behind it
            let background = NSCollectionLayoutDecorationItem.background(elementKind: PaywallSectionBackgroundView.elementKind)
            background.zIndex = -1
            section.decorationItems = [background]
            return section
        }
        layout.register(PaywallSectionBackgroundView.self, forDecorationViewOfKind: PaywallSectionBackgroundView.elementKind)
        return layout
    }

    // MARK: Boilerplate

    private let isModal: Bool
    let viewModel: PaywallViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Int, PaywallItem>?
    private var loadTask: Task<Void, Never>?
    private var hasLoggedAppearance = false

    @Injected(\.logger) private var logger

    var showsCloseButton: Bool {
        #if targetEnvironment(macCatalyst)
        false
        #else
        isModal
        #endif
    }

    let footerView = PaywallFooterView()

    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: PaywallViewController.layout)
        collectionView.backgroundColor = .clear
        collectionView.indicatorStyle = .white
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}

final class PaywallSectionBackgroundView: UICollectionReusableView {
    static let elementKind = "PaywallSectionBackgroundView.elementKind"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .primary
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}

extension Event.Name {
    static let purchaseMarketingDisplayed = Event.Name("PurchaseMarketingView.displayed")
}
