//  Created by Geoff Pado on 8/27/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import UIKit

class DismissBarButtonItem: UIBarButtonItem {
    override init() {
        super.init()
        self.style = .done
        self.title = Self.title
        self.action = #selector(PhotoEditingActions.dismissPhotoEditingViewController)
    }

    private static let title = NSLocalizedString("DismissBarButtonItem.title", comment: "Title for the dismiss button")

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
