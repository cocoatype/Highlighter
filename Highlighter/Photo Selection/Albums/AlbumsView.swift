//  Created by Geoff Pado on 5/16/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import UIKit

class AlbumsView: UITableView {
    init(dataSource: CollectionsDataSource) {
        let bounds = UIScreen.main.bounds // this is to fix a bug with cell layout on iOS 12
        super.init(frame: bounds, style: .plain)
        backgroundColor = .primary
        separatorColor = .primaryLight
        separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        self.dataSource = dataSource

        register(SystemCollectionTableViewCell.self, forCellReuseIdentifier: SystemCollectionTableViewCell.identifier)
        register(UserCollectionTableViewCell.self, forCellReuseIdentifier: UserCollectionTableViewCell.identifier)
        register(AlbumsHeaderView.self, forHeaderFooterViewReuseIdentifier: AlbumsHeaderView.identifier)
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
}

class AlbumsSidebarView: UICollectionView {
    init(dataSource: CollectionsDataSource) {
        let layout = AlbumsSidebarLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        backgroundColor = .primary
        self.dataSource = dataSource

        register(AlbumsSidebarCell.self, forCellWithReuseIdentifier: AlbumsSidebarCell.identifier)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}

class AlbumsSidebarCell: UICollectionViewListCell {
    static let identifier = "AlbumsSidebarCell.identifier"
}

class AlbumsSidebarLayout: UICollectionViewCompositionalLayout {
    init(void: Void = ()) {
        super.init { _, environment -> NSCollectionLayoutSection? in
            return NSCollectionLayoutSection.albumsSidebar(layoutEnvironment: environment)
        }
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}

extension UICollectionLayoutListConfiguration {
    static var albumsSidebar: UICollectionLayoutListConfiguration = {
        let configuration = UICollectionLayoutListConfiguration(appearance: .sidebar)
        return configuration
    }()
}

extension NSCollectionLayoutSection {
    static func albumsSidebar(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        return NSCollectionLayoutSection.list(using: .albumsSidebar, layoutEnvironment: layoutEnvironment)
    }
}


