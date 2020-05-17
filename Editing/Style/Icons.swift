//  Created by Geoff Pado on 7/29/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

public enum Icons {
    @available(iOS 13.0, *)
    public static let scanDocument = UIImage(systemName: "doc.text.viewfinder")

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

    // MARK: Collections

    public static var favoritesCollection: UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(systemName: "suit.heart")
        }

        return nil
    }

    public static var recentsCollection: UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(systemName: "clock")
        }

        return nil
    }

    public static var screenshotsCollection: UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(systemName: "camera.viewfinder")
        }

        return nil
    }
}
