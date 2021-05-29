//  Created by Geoff Pado on 7/29/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

public enum Icons {
    @available(iOS 13.0, *)
    public static let scanDocument = UIImage(systemName: "doc.text.viewfinder")

    @available(iOS 14.0, *)
    public static let limitedLibrary = UIImage(systemName: "rectangle.stack.badge.plus")

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
            return UIImage(systemName: "gear")
        }

        return UIImage(named: "Help")
    }

    public static var albums: UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(systemName: "rectangle.stack")
        }

        return UIImage(named: "Albums")
    }

    // MARK: Collections

    public static var favoritesCollection: UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(systemName: "suit.heart")?.withRenderingMode(.alwaysTemplate)
        }

        return UIImage(named: "Favorites Album")
    }

    public static var recentsCollection: UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(systemName: "clock")?.withRenderingMode(.alwaysTemplate)
        }

        return UIImage(named: "Recents Album")
    }

    public static var screenshotsCollection: UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(systemName: "camera.viewfinder")?.withRenderingMode(.alwaysTemplate)
        }

        return UIImage(named: "Screenshots Album")
    }

    public static var standardCollection: UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(systemName: "rectangle.stack")?.withRenderingMode(.alwaysTemplate)
        }

        return UIImage(named: "Screenshots Album")
    }
}
