//  Created by Geoff Pado on 7/15/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Combine
import UIKit

import AlbumsData
import AppNavigation
import DesignSystem

public class AlbumsViewController: UIViewController, UICollectionViewDelegate {
    public init(
        dataSource: PhotoCollectionsDataSource = PhotoCollectionsDataSource(),
        selectedCollectionIdentifier: String? = PhotoCollectionType.library.defaultCollection.identifier
    ) {
        self.photoCollectionsDataSource = dataSource
        self.selectedCollectionIdentifier = selectedCollectionIdentifier
        super.init(nibName: nil, bundle: nil)

        navigationItem.title = Strings.AlbumsViewController.navigationTitle
    }

    public override func loadView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: Self.layout)
        collectionView.backgroundColor = .primary
        collectionView.indicatorStyle = .white
        collectionView.tintColor = .white
        collectionView.delegate = self
        view = collectionView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        collectionsDataCancellable = photoCollectionsDataSource.$collectionsData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sections in
                self?.apply(sections)
            }
    }

    // MARK: Data

    private func apply(_ sections: [PhotoCollectionSection]) {
        collectionsByIdentifier = Dictionary(
            sections.flatMap(\.collections).map { ($0.identifier, $0) },
            uniquingKeysWith: { first, _ in first }
        )

        var snapshot = AlbumsSnapshotBuilder.snapshot(from: sections)
        // collection titles can change without their identifier changing
        snapshot.reconfigureItems(snapshot.itemIdentifiers)
        diffableDataSource.apply(snapshot, animatingDifferences: hasAppliedSnapshot)
        hasAppliedSnapshot = true

        if let selectedCollectionIdentifier, let indexPath = diffableDataSource.indexPath(for: selectedCollectionIdentifier) {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
    }

    // MARK: UICollectionViewDelegate

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let identifier = diffableDataSource.itemIdentifier(for: indexPath),
              let collection = collectionsByIdentifier[identifier]
        else { return }

        selectedCollectionIdentifier = identifier
        next?.collectionPresenter?.present(collection)
    }

    // MARK: Layout

    private static var layout: UICollectionViewLayout {
        UICollectionViewCompositionalLayout { _, environment in
            var configuration = UICollectionLayoutListConfiguration(appearance: .sidebar)
            configuration.headerMode = .supplementary
            configuration.backgroundColor = .primary
            return NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: environment)
        }
    }

    // MARK: Cells

    private lazy var cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { [weak self] cell, _, identifier in
        guard let collection = self?.collectionsByIdentifier[identifier] else { return }
        cell.configurationUpdateHandler = { cell, state in
            guard let cell = cell as? UICollectionViewListCell else { return }
            cell.contentConfiguration = AlbumsCellConfiguration.content(for: collection, state: state)
            cell.backgroundConfiguration = AlbumsCellConfiguration.background(for: state)
        }
    }

    private lazy var headerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(
        elementKind: UICollectionView.elementKindSectionHeader
    ) { [weak self] header, _, indexPath in
        guard let title = self?.diffableDataSource.sectionIdentifier(for: indexPath.section) else { return }
        header.contentConfiguration = AlbumsCellConfiguration.header(title: title)
        var background = UIBackgroundConfiguration.clear()
        background.backgroundColor = .clear
        header.backgroundConfiguration = background
    }

    private lazy var diffableDataSource: UICollectionViewDiffableDataSource<String, String> = {
        let cellRegistration = cellRegistration
        let headerRegistration = headerRegistration
        let dataSource = UICollectionViewDiffableDataSource<String, String>(collectionView: collectionView) { collectionView, indexPath, identifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        return dataSource
    }()

    // MARK: Boilerplate

    private let photoCollectionsDataSource: PhotoCollectionsDataSource
    private var collectionsDataCancellable: AnyCancellable?
    private var collectionsByIdentifier = [String: PhotoCollection]()
    private var selectedCollectionIdentifier: String?
    private var hasAppliedSnapshot = false

    // swiftlint:disable:next force_cast
    private var collectionView: UICollectionView { view as! UICollectionView }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
