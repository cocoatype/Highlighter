//  Created by Geoff Pado on 12/20/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import UIKit

import FactoryKit

import ErrorHandling

public final class DesktopSeekViewController: UIViewController {
    public init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }

    override public func loadView() {
        view = DesktopSeekContainerView()
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        Container.shared.errorHandler().notImplemented()
    }
}
