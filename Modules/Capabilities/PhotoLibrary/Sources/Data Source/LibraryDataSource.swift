//  Created by Geoff Pado on 5/31/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

protocol LibraryDataSource {
    var itemsCount: Int { get }
    func item(at index: Int) -> PhotoLibraryItem
}
