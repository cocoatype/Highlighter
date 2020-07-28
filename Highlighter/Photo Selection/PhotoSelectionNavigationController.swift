//  Created by Geoff Pado on 4/8/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import SwiftUI
import UIKit

class PhotoSelectionViewController: UIHostingController<PhotoSelection> {
    init() {
        UITableView.appearance().backgroundColor = .primary
        UITableViewCell.appearance().selectionStyle = .none
        UICollectionView.appearance().backgroundColor = .primary
        UINavigationBar.appearance().scrollEdgeAppearance = NavigationBarAppearance()
        UIBarButtonItem.appearance().tintColor = .white

        let albumsDataSource = CollectionsDataSource()
        self.albumsDataSource = albumsDataSource

        super.init(rootView: PhotoSelection(data: albumsDataSource.collectionsData))
    }

    // MARK: Boilerplate

    private let albumsDataSource: CollectionsDataSource

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}

struct PhotoSelection: View {
    init(data: [CollectionSection]) {
        self.collectionsData = data
    }

    var body: some View {
        NavigationView {
            AlbumsList(data: collectionsData)
            PhotoLibraryView(dataSource: PhotoLibraryDataSource(initialCollection)).navigationBarTitleDisplayMode(.inline)
        }.accentColor(.primaryLight)
    }

    private var initialCollection: Collection {
        guard let firstCollection = collectionsData.first?.collections.first else { return EmptyCollection() }
        return firstCollection
    }

    private let collectionsData: [CollectionSection]
}

struct PhotoSelection_Previews: PreviewProvider {
    static var previews: some View {
        PhotoSelection(data: AlbumsList_Previews.fakeData)
            .previewDevice("iPad Pro (9.7-inch)")
    }
}
