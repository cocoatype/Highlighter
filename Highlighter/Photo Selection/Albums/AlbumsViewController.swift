//  Created by Geoff Pado on 5/16/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

class AlbumsViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = albumsView
    }

    // MARK: Boilerplate

    private let albumsDataSource = CollectionsDataSource()
    private lazy var albumsView = AlbumsView(dataSource: albumsDataSource)

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
}
