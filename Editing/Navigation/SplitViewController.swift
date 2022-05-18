//  Created by Geoff Pado on 9/30/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import UIKit

open class SplitViewController: UISplitViewController {
    public init(primaryViewController: UIViewController, secondaryViewController: UIViewController) {
        super.init(style: .doubleColumn)
        setViewController(primaryViewController, for: .primary)
        setViewController(secondaryViewController, for: .secondary)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryDark
    }

    // MARK: Status Bar

    open override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    open override var childForStatusBarStyle: UIViewController? { return nil }

    // MARK: Boilerplate

    @available(*, unavailable)
    public required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
