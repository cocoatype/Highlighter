//  Created by Geoff Pado on 12/6/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Foundation

public enum FeatureFlag {
    static var seekAndDestroy: Bool {
        UserDefaults.standard.bool(forKey: "FeatureFlag.seekAndDestroy")
    }

    public static var newFromClipboard: Bool {
        UserDefaults.standard.bool(forKey: "FeatureFlag.newFromClipboard")
    }
}
