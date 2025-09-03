//  Created by Geoff Pado on 9/2/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

#if targetEnvironment(macCatalyst)
import Foundation

class ZoomItemGroup: NSToolbarItemGroup {
    static let identifier = NSToolbarItem.Identifier("ZoomItemGroup.identifier")

    static let zoomStops = [
        0.05, 0.1, 0.15, 0.2, 0.3, 0.4, 0.5, 0.75, 1.0, 1.5,
        2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0,
        12.0, 13.0, 14.0, 15.0, 16.0, 17.0, 18.0, 19.0, 20.0, 21.0,
        22.0, 23.0, 24.0, 25.0, 26.0, 27.0, 28.0, 29.0, 30.0,
    ]
 
    init(delegate: any ZoomItemDelegate) {
        super.init(itemIdentifier: Self.identifier)
        label = CoreStrings.ZoomItemGroup.label
        subitems = [ZoomOutItem(delegate: delegate), ZoomInItem(delegate: delegate)]
    }
}
#endif
