//  Created by Geoff Pado on 7/15/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import SwiftUI

@available(iOS 14.0, *)
struct AlbumsList: View {
    @State var selectedCollectionIdentifier: String?
    let data: [CollectionSection]
    init(data: [CollectionSection]) {
        self.data = data
    }

    var body: some View {
        List(selection: $selectedCollectionIdentifier) {
            ForEach(data, id: \.title) { section in
                Section(header: AlbumsSectionHeader(section.title)) {
                    ForEach(section.collections, id: \.identifier) { collection in
                        AlbumsRow(collection)
                    }
                }.accentColor(.white)
            }
        }
        .listStyle(SidebarListStyle())
        .navigationTitle("Photos")
    }
}

@available(iOS 14.0, *)
struct AlbumsSectionHeader: View {
    private let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text).font(Font.app(textStyle: .title3))
    }
}

struct AlbumsRow: View {
    private let collection: Collection
    init(_ collection: Collection) {
        self.collection = collection
    }

    var body: some View {
        let destination = PhotoLibraryView(dataSource: PhotoLibraryDataSource(collection))
        NavigationLink(destination: destination) {
            Label(
                title: { Text(collection.title ?? "") },
                icon: { Image(uiImage: collection.icon ?? UIImage()).foregroundColor(.white) }
            ).font(Font.app(textStyle: .body))
            .foregroundColor(.white)
            .id(collection.identifier)
            .tag(collection.identifier)
        }
    }
}

@available(iOS 14.0, *)
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
        AlbumsRow(fakeData[0].collections[0])
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
