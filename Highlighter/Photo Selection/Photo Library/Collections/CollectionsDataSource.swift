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
          .map(Collection.init)
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

    // MARK: UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections(forSection: section).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as? CollectionTableViewCell else { fatalError("Cell was not a collection cell") }
        cell.collection = collection(at: indexPath)
        return cell
    }
}
