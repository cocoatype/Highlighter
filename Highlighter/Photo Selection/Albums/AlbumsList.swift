//  Created by Geoff Pado on 7/15/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import SwiftUI

@available(iOS 14.0, *)
struct AlbumsList: View {
    @State private var selectedCollectionIdentifier: String?
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
    }
}

@available(iOS 14.0, *)
struct AlbumsSectionHeader: View {
    private let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text).font(Font.app(textStyle: .title3)).foregroundColor(.white)
    }
}

@available(iOS 14.0, *)
struct AlbumsRow: View {
    let selection: Binding<String?>
    private let collection: Collection
    init(_ collection: Collection, selection: Binding<String?>) {
        self.collection = collection
        self.selection = selection
    }

    var body: some View {
        Button {
            navigationWrapper.present(collection)
        } label: {
            Label(
                title: { Text(collection.title ?? "") },
                icon: { Image(uiImage: collection.icon ?? UIImage()).foregroundColor(.white) }
            ).font(.sidebarItem)
            .foregroundColor(.white)
            .id(collection.identifier)
            .tag(collection.identifier)
        }
    }

    @EnvironmentObject private var navigationWrapper: NavigationWrapper
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
