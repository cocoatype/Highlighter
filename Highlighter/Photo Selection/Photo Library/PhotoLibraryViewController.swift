//  Created by Geoff Pado on 7/1/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import SwiftUI
import UIKit

@available(iOS 14.0, *)
class PhotoLibraryViewController: UIHostingController<PhotoLibraryView> {
    init(collection: Collection) {
        let dataSource = PhotoLibraryDataSource(collection)
        super.init(rootView: PhotoLibraryView(dataSource: dataSource))
    }
    
    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
