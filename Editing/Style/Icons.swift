//  Created by Geoff Pado on 7/29/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

public enum Icons {
    static var undo: UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(systemName: "arrow.uturn.left")
        }

        return UIImage(named: "Undo")
    }

    static var redo: UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(systemName: "arrow.uturn.right")
        }

        return UIImage(named: "Redo")
    }

    public static var help: UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(systemName: "questionmark.circle")
        }

        return UIImage(named: "Help")
    }
}
