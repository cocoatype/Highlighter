//  Created by Geoff Pado on 7/15/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import AlbumsData
import AppNavigation
import Photos
import SwiftUI

public struct AlbumsList: View {
    @State private var selectedCollectionIdentifier: String?
    @StateObject private var dataSource = PhotoCollectionsDataSource()

    var navigationWrapper = NavigationWrapper.empty
    init(selectedCollectionIdentifier: String? = PhotoCollectionType.library.defaultCollection.identifier) {
        self.selectedCollectionIdentifier = selectedCollectionIdentifier
    }

    public var body: some View {
        List(selection: $selectedCollectionIdentifier) {
            ForEach(dataSource.collectionsData, id: \.title) { section in
                Section(header: AlbumsSectionHeader(section.title)) {
                    ForEach(section.collections, id: \.identifier) { collection in
                        AlbumsRow(collection, selection: $selectedCollectionIdentifier)
                    }
                }.accentColor(.white)
            }
        }
        .listStyle(SidebarListStyle())
        .navigationTitle(AlbumsUIStrings.AlbumsViewController.navigationTitle)
        .environmentObject(navigationWrapper)
        .albumsListBackground()
    }
}

enum AlbumsListPreviews: PreviewProvider {
    struct DummyCollection: PhotoCollection {
        let title: String?
        let icon: String
        let identifier: String
        var assets: PHFetchResult<PHAsset> { .init() }

        init(title: String, iconName: String) {
            self.title = title
            self.icon = iconName
            self.identifier = title
        }
    }

    static let fakeData = [
        PhotoCollectionSection(title: "Smart Collections", collections: [
            DummyCollection(title: "Recent Photos", iconName: "clock"),
            DummyCollection(title: "Screenshots", iconName: "camera.viewfinder"),
            DummyCollection(title: "Favorites", iconName: "suit.heart"),
        ]),
        PhotoCollectionSection(title: "User Collections", collections: []),
    ]

    static var previews: some View {
        AlbumsList(selectedCollectionIdentifier: nil)
            .preferredColorScheme(.dark)
    }
}
