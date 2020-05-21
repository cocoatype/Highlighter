//  Created by Geoff Pado on 5/16/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import UIKit

class CollectionsDataSource: NSObject, UITableViewDataSource {
    lazy var allCollections: [Collection] = {
        return [CollectionType.library, .screenshots, .userAlbum, .favorites]
          .map { $0.fetchResult }
          .flatMap { $0.objects(at: IndexSet(integersIn: 0..<$0.count)) }
          .map(Collection.init)
    }()

    // MARK: UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCollections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as? CollectionTableViewCell else { fatalError("Cell was not a collection cell") }
        cell.collection = allCollections[indexPath.row]
        return cell
    }
}
