//  Created by Geoff Pado on 5/16/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

class LegacyAlbumsViewController: UIViewController, UITableViewDelegate, UICollectionViewDelegate {
    init() {
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = Self.navigationTitle
    }

    override func loadView() {
        albumsView.delegate = self
//        albumsView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
        view = albumsView
    }

    // MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collection = albumsDataSource.collection(at: indexPath)
        let event = CollectionEvent(collection)
//        UIApplication.shared.sendAction(#selector(PhotoSelectionSplitViewController.showCollection(_:for:)), to: nil, from: self, for: event)
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 36 : 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? UITableView.automaticDimension : 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 1 else { return nil }
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: AlbumsHeaderView.identifier)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001 // to hide remaining cells
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }

    // MARK: Boilerplate

    private static let navigationTitle = NSLocalizedString("AlbumsViewController.navigationTitle", comment: "Navigation title for the albums list")

    private let albumsDataSource = CollectionsDataSource()
    private lazy var albumsView = AlbumsSidebarView(dataSource: albumsDataSource)

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
}
