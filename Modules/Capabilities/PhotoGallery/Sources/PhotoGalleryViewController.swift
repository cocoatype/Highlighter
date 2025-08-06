//  Created by Geoff Pado on 8/6/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import SwiftUI
import UIKit

@available(iOS 26.0, *)
public class PhotoGalleryViewController: UIHostingController<PhotoGalleryContainer> {
    public init() {
        super.init(rootView: PhotoGalleryContainer())
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
