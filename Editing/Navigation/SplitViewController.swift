//  Created by Geoff Pado on 9/30/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import UIKit

@available(iOS 14.0, *)
public class SplitViewController: UISplitViewController {
    public init(primaryViewController: UIViewController, secondaryViewController: UIViewController) {
        super.init(style: .doubleColumn)
        setViewController(primaryViewController, for: .primary)
        setViewController(secondaryViewController, for: .secondary)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
