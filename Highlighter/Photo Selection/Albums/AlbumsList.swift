//  Created by Geoff Pado on 7/15/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct AlbumsList: View {
    @State private var selectedCollectionIdentifier: String? = CollectionType.library.defaultCollection.identifier
    var navigationWrapper = NavigationWrapper.empty
    let data: [CollectionSection]
    init(data: [CollectionSection]) {
        self.data = data
    }

    var body: some View {
        return List(selection: $selectedCollectionIdentifier) {
            ForEach(data, id: \.title) { section in
                Section(header: AlbumsSectionHeader(section.title)) {
                    ForEach(section.collections, id: \.identifier) { collection in
                        AlbumsRow(collection, selection: $selectedCollectionIdentifier)
                    }
                }.accentColor(.white)
            }
        }
        .listStyle(SidebarListStyle())
        .navigationTitle("AlbumsViewController.navigationTitle")
        .environmentObject(navigationWrapper)
        .introspectTableView { $0.backgroundColor = .primary }
    }
}

struct AlbumsList_Previews: PreviewProvider {
    static let fakeData = [
        CollectionSection(title: "Smart Collections", collections: [
            DummyCollection(title: "Recent Photos", iconName: "clock"),
            DummyCollection(title: "Screenshots", iconName: "camera.viewfinder"),
            DummyCollection(title: "Favorites", iconName: "suit.heart"),
        ]),
        CollectionSection(title: "User Collections", collections: [])
    ]

    static var previews: some View {
        AlbumsList(data: fakeData)
            .preferredColorScheme(.dark)
    }
}

struct DummyCollection: Collection {
    let title: String?
    let icon: UIImage?
    let identifier: String

    init(title: String, iconName: String) {
        self.title = title
        self.icon = UIImage(systemName: iconName)?.withRenderingMode(.alwaysTemplate)
        self.identifier = title
    }
}
