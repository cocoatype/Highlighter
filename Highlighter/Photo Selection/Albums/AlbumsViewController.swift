//  Created by Geoff Pado on 7/15/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import SwiftUI

@available(iOS 14.0, *)
class AlbumsViewController: UIHostingController<AlbumsList> {
    init() {
        let albumsDataSource = CollectionsDataSource()
        self.albumsDataSource = albumsDataSource

        let albumsList = AlbumsList(data: albumsDataSource.collectionsData)
        super.init(rootView: albumsList)

//        let binding =
    }

    // MARK: Boilerplate

    private let albumsDataSource: CollectionsDataSource

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
