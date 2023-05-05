//  Created by Geoff Pado on 5/16/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import ErrorHandling
import UIKit

class CollectionsDataSource: NSObject {
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

    // MARK: SwiftUI Data Source

    var collectionsData: [CollectionSection] {[
        CollectionSection(title: Self.smartAlbumsHeader, collections: smartCollections),
        CollectionSection(title: Self.userAlbumsHeader, collections: userCollections)
    ]}

    // MARK: Localizable Strings

    private static let smartAlbumsHeader = NSLocalizedString("CollectionsDataSource.smartAlbumsHeader", comment: "Header for the smart albums section in the albums list")
    private static let userAlbumsHeader = NSLocalizedString("CollectionsDataSource.userAlbumsHeader", comment: "Header for the user albums section in the albums list")
}
