//  Created by Geoff Pado on 1/10/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import UIKit

public final class TabletSeekViewController: UIViewController {
    public init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .popover
        updatePreferredContentSize()
    }

    override public func loadView() {
        view = seekView
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        seekView.activate()
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePreferredContentSize()
    }

    private func updatePreferredContentSize() {
        let intrinsicHeight = TabletSeekSearchBar().intrinsicContentSize.height
        let widthRatio = 320.0 / 56.0
        preferredContentSize = CGSize(width: widthRatio * intrinsicHeight, height: intrinsicHeight)
    }

    // MARK: Boilerplate

    private let seekView = TabletSeekView()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
