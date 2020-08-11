//  Created by Geoff Pado on 5/16/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import UIKit

class CollectionsDataSource: NSObject, UITableViewDataSource {
    lazy var smartCollections: [Collection] = {
        return allCollections(types: [CollectionType.library, .screenshots, .favorites])
    }()

    lazy var userCollections: [Collection] = {
        return allCollections(types: [CollectionType.userAlbum])
    }()

    private func allCollections(types: [CollectionType]) -> [Collection] {
        return types
          .map { $0.fetchResult }
          .flatMap { $0.objects(at: IndexSet(integersIn: 0..<$0.count)) }
          .map(AssetCollection.init)
    }

    // MARK: Data Access

    private func collections(forSection section: Int) -> [Collection] {
        switch section {
        case 0: return smartCollections
        case 1: return userCollections
        default: return []
        }
    }

    func collection(at indexPath: IndexPath) -> Collection {
        return collections(forSection: indexPath.section)[indexPath.row]
    }

    private func dequeueTableViewCell(for tableView: UITableView, at indexPath: IndexPath) -> (UITableViewCell & CollectionTableViewCell) {
        let cellType: CollectionTableViewCell.Type
        switch indexPath.section {
        case 0: cellType = SystemCollectionTableViewCell.self
        case 1: cellType = UserCollectionTableViewCell.self
        default: fatalError()
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as? (UITableViewCell & CollectionTableViewCell) else { fatalError("Cell was not a collection cell") }
        return cell
    }

    // MARK: SwiftUI Data Source

    var collectionsData: [CollectionSection] {[
        CollectionSection(title: Self.smartAlbumsHeader, collections: smartCollections),
        CollectionSection(title: Self.userAlbumsHeader, collections: userCollections)
    ]}

    // MARK: UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections(forSection: section).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = dequeueTableViewCell(for: tableView, at: indexPath)
        cell.collection = collection(at: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 1 else { return nil }
        return Self.userAlbumsHeader
    }

    // MARK: Localizable Strings

    private static let smartAlbumsHeader = NSLocalizedString("CollectionsDataSource.smartAlbumsHeader", comment: "Header for the smart albums section in the albums list")
    private static let userAlbumsHeader = NSLocalizedString("CollectionsDataSource.userAlbumsHeader", comment: "Header for the user albums section in the albums list")
}
