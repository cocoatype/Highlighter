//  Created by Geoff Pado on 5/18/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

protocol AppEntryOpening {
    func openAppStore(displaying appEntry: AppEntry)
}

extension UIResponder {
    var appEntryOpener: AppEntryOpening? {
        if let opener = (self as? AppEntryOpening) {
            return opener
        }

        return next?.appEntryOpener
    }
}
