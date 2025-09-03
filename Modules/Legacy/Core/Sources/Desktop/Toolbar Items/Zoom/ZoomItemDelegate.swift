//  Created by Geoff Pado on 9/2/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

#if targetEnvironment(macCatalyst)
@objc @MainActor protocol ZoomItemDelegate: AnyObject {
    @objc func zoomIn(_ sender: NSToolbarItem)
    @objc func zoomOut(_ sender: NSToolbarItem)
}
#endif
