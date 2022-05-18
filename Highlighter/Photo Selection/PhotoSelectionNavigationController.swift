//  Created by Geoff Pado on 4/8/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import Introspect
import Photos
import SwiftUI
import UIKit

struct PhotoSelection: View {
    init(data: [CollectionSection]) {
        self.collectionsData = data
    }

    var body: some View {
        NavigationView {
            AlbumsList(data: collectionsData)
        }.accentColor(.primaryLight).introspectNavigationController { navigationController in
            let navigationBar = navigationController.navigationBar
            navigationBar.standardAppearance = NavigationBarAppearance()
        }
    }

    static func hostingController(presenter: NavigationWrapper.NavigationObject) -> UIViewController {
        let albumsDataSource = CollectionsDataSource()
        let selectionView = PhotoSelection(data: albumsDataSource.collectionsData)
            .environmentObject(NavigationWrapper(navigationObject: presenter))
        return UIHostingController(rootView: selectionView)
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
            .previewDevice("iPad Pro (9.7-inch)").preferredColorScheme(.dark)
    }
}
