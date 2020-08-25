//  Created by Geoff Pado on 4/8/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Photos
import Editing
import SwiftUI
import UIKit

class NavigationWrapper: NSObject, ObservableObject {
    typealias NavigationObject = (SettingsPresenting & PhotoEditorPresenting & DocumentScannerPresenting)
    init(navigationObject: NavigationObject) {
        self.navigationObject = navigationObject
    }

    func presentSettings() {
        navigationObject.presentSettingsViewController()
    }

    func presentEditor(for asset: PHAsset) {
        navigationObject.presentPhotoEditingViewController(for: asset, redactions: nil, animated: true)
    }

    func presentDocumentScanner() {
        navigationObject.presentDocumentCameraViewController()
    }

    private let navigationObject: NavigationObject
}

@available(iOS 14.0, *)
struct PhotoSelection: View {
    init(data: [CollectionSection]) {
        self.collectionsData = data
    }

    var body: some View {
        NavigationView {
            AlbumsList(data: collectionsData)
            PhotoLibraryView(dataSource: PhotoLibraryDataSource(initialCollection))
        }.accentColor(.primaryLight)
    }

    static func hostingController(presenter: NavigationWrapper.NavigationObject) -> UIViewController {
        UITableView.appearance().backgroundColor = .primary
        UITableViewCell.appearance().selectionStyle = .none
        UICollectionView.appearance().backgroundColor = .primary
        UINavigationBar.appearance().scrollEdgeAppearance = NavigationBarAppearance()
        UIBarButtonItem.appearance().tintColor = .white

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

@available(iOS 14.0, *)
struct PhotoSelection_Previews: PreviewProvider {
    static var previews: some View {
        PhotoSelection(data: AlbumsList_Previews.fakeData)
            .previewDevice("iPad Pro (9.7-inch)")
    }
}
