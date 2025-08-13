//  Created by Geoff Pado on 9/28/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import SwiftUI
import UIKit

public class DesktopSettingsViewController: UIHostingController<DesktopSettingsView> {
    public init() {
        super.init(rootView: DesktopSettingsView())
    }

    public override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        updateReadableWidth()
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateReadableWidth()
    }

    private func updateReadableWidth() {
        let readableWidth = view.readableContentGuide.layoutFrame.width
        rootView = DesktopSettingsView(readableWidth: readableWidth)
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
