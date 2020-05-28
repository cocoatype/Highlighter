//  Created by Geoff Pado on 5/16/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import UIKit

class AlbumsView: UITableView {
    init(dataSource: CollectionsDataSource) {
        super.init(frame: .zero, style: .plain)
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
