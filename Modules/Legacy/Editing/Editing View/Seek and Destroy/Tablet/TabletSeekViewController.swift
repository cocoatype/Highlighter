//  Created by Geoff Pado on 1/10/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import SwiftUI

class TabletSeekViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .popover
        updatePreferredContentSize()
    }

    override func loadView() {
        view = seekView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        seekView.activate()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
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
