//  Created by Geoff Pado on 8/12/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import UIKit

protocol SettingsPresenting {
    func presentSettingsViewController()
}

extension UIResponder {
    var settingsPresenter: SettingsPresenting? {
        if let settingsPresenter = (self as? SettingsPresenting) {
            return settingsPresenter
        }

        return next?.settingsPresenter
    }
}
