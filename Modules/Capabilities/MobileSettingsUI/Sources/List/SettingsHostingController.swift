//  Created by Geoff Pado on 5/17/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI
import UIKit

public class SettingsHostingController: UIHostingController<SettingsView> {
    public init() {
        super.init(rootView: SettingsView(dismissAction: {}))
        modalPresentationStyle = .formSheet
        preferredContentSize = CGSize(width: 640, height: 640)
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        let readableWidth = view.readableContentGuide.layoutFrame.width
        rootView = SettingsView(readableWidth: readableWidth, dismissAction: { [weak self] in
            self?.dismissSettings()
        })
    }

    private func dismissSettings() {
        UIApplication.shared.sendAction(#selector(SettingsHostingControllerActions.dismissSettingsViewController), to: nil, from: self, for: nil)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}

@objc protocol SettingsHostingControllerActions {
    func dismissSettingsViewController()
}
