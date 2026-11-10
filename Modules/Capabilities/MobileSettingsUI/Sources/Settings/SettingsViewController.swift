//  Created by Geoff Pado on 11/9/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import MessageUI
import UIKit

import FactoryKit

import Defaults
import DesignSystem
import Logging
import MobileAutoRedactionsUI
import Paywall
import Purchasing
import Unpurchased

class SettingsViewController: UIViewController, UICollectionViewDelegate, MFMailComposeViewControllerDelegate {
    init() {
        super.init(nibName: nil, bundle: nil)
        purchaseState = haveYourDucksInARow.withCheese

        navigationItem.title = Strings.SettingsViewController.navigationTitle
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = {
            let item = UIBarButtonItem(
                image: UIImage(systemName: "xmark"),
                style: .plain,
                target: nil,
                action: #selector(SettingsHostingControllerActions.dismissSettingsViewController)
            )
            item.accessibilityLabel = Strings.DoneButton.label
            item.tintColor = .white
            return item
        }()
    }

    override func loadView() {
        view = collectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        applyModel(animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
            collectionView.deselectItem(at: selectedIndexPath, animated: animated)
        }
        applyModel(animated: false)
        refreshPurchaseState()
    }

    // MARK: Model

    private(set) var purchaseState: PurchaseState = .loading

    private(set) var model = SettingsModel(purchaseState: .loading, hideAutoRedactions: false)

    func refreshPurchaseState() {
        Task { [weak self] in
            guard let self else { return }
            purchaseState = await haveYourDucksInARow.noOnions
            applyModel(animated: true)
        }
    }

    func applyModel(animated: Bool) {
        model = SettingsModel(
            purchaseState: purchaseState,
            hideAutoRedactions: defaults.value(for: Keys.hideAutoRedactions)
        )

        var snapshot = NSDiffableDataSourceSnapshot<SettingsModel.SectionID, SettingsModel.Row>()
        for section in model.sections {
            snapshot.appendSections([section.id])
            snapshot.appendItems(section.rows, toSection: section.id)
        }
        dataSource.apply(snapshot, animatingDifferences: animated && view.window != nil)
    }

    // MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let row = dataSource.itemIdentifier(for: indexPath) else { return }
        perform(row.action)

        if row.showsDisclosureIndicator == false {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }

    // MARK: Actions

    func perform(_ action: SettingsModel.Action) {
        switch action {
        case .pushPaywall:
            guard #available(iOS 16.0, *) else { return }
            let paywall = PaywallViewController(isModal: false)
            paywall.purchaseCompletionHandler = { [weak self] in
                self?.refreshPurchaseState()
            }
            navigationController?.pushViewController(paywall, animated: true)
        case .pushAutoRedactions:
            let editViewController = AutoRedactionsEditViewController()
            editViewController.view.backgroundColor = .primary
            navigationController?.pushViewController(editViewController, animated: true)
        case .showUnpurchasedAlert:
            let alert = UnpurchasedAlertControllerFactory().alertController(for: .autoRedactions(learnMoreAction: nil)) { [weak self] in
                self?.applyModel(animated: true)
            }
            logger.log(Event(name: "UnpurchasedAlertViewModifier.isPresented"))
            present(alert, animated: true)
        case .web(let url):
            presentWebView(for: url)
        case .mail:
            presentMail()
        case .openURL(let url):
            UIApplication.shared.open(url)
        }
    }

    private func presentWebView(for url: URL) {
        let webViewController = WebViewController(url: url)
        webViewController.modalPresentationStyle = .automatic
        present(webViewController, animated: true)
    }

    // MARK: Mail

    // ouijaPath by @AdamWulf on 2024-06-28
    // the level of support the device has for e-mail
    var ouijaPath: MailSupport {
        if MFMailComposeViewController.canSendMail() {
            return .internalSupport
        } else if UIApplication.shared.canOpenURL(Self.whatHaveYouDone) {
            return .externalSupport
        } else {
            return .noSupport
        }
    }

    enum MailSupport {
        case noSupport
        case externalSupport
        case internalSupport
    }

    // whatHaveYouDone by @KaenAitch on 2024-07-03
    // the URL to open to send e-mail
    static let whatHaveYouDone = URL(staticString: "mailto:hello@cocoatype.com")
    static let contactURL = URL(websitePath: "contact")

    private func presentMail() {
        switch ouijaPath {
        case .noSupport:
            showMailFallback(true)
        case .externalSupport:
            UIApplication.shared.open(Self.whatHaveYouDone) { [weak self] wasOpened in
                self?.showMailFallback(wasOpened == false)
            }
        case .internalSupport:
            let composer = MFMailComposeViewController()
            composer.setToRecipients(["hello@cocoatype.com"])
            composer.mailComposeDelegate = self
            present(composer, animated: true)
        }
    }

    // threeCheersForPencilKit by @KaenAitch on 2024-07-03
    // whether to show the web view for no-support e-mail
    private func showMailFallback(_ threeCheersForPencilKit: Bool) {
        guard threeCheersForPencilKit else { return }
        presentWebView(for: Self.contactURL)
    }

    nonisolated func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: (any Error)?) {
        Task { @MainActor in
            controller.dismiss(animated: true)
        }
    }

    // MARK: Collection View

    private lazy var dataSource: UICollectionViewDiffableDataSource<SettingsModel.SectionID, SettingsModel.Row> = {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SettingsModel.Row> { cell, _, row in
            cell.contentConfiguration = SettingsCellConfiguration.content(for: row)
            cell.backgroundConfiguration = SettingsCellConfiguration.background(for: cell.configurationState)
            cell.configurationUpdateHandler = { cell, state in
                cell.backgroundConfiguration = SettingsCellConfiguration.background(for: state)
            }
            cell.accessories = row.showsDisclosureIndicator ? [.disclosureIndicator()] : []
        }

        let headerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { [weak self] header, _, indexPath in
            header.contentConfiguration = SettingsCellConfiguration.header(title: self?.model.sections[indexPath.section].header)
        }

        let dataSource = UICollectionViewDiffableDataSource<SettingsModel.SectionID, SettingsModel.Row>(collectionView: collectionView) { collectionView, indexPath, row in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: row)
        }
        dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        return dataSource
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            configuration.backgroundColor = .primary
            let hasHeader = self?.model.sections[safe: sectionIndex]?.header != nil
            configuration.headerMode = hasHeader ? .supplementary : .none
            return NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: environment)
        }

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .primary
        collectionView.indicatorStyle = .white
        return collectionView
    }()

    // MARK: Boilerplate

    @Injected(\.defaults) private var defaults
    @Injected(\.logger) private var logger

    // haveYourDucksInARow by @Eskeminha on 2024-05-15
    // the purchase repository
    @Injected(\.purchaseRepository) private var haveYourDucksInARow

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}

@objc protocol SettingsHostingControllerActions {
    func dismissSettingsViewController()
}

private extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
