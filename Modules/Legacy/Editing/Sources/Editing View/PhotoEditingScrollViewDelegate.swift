//  Created by Geoff Pado on 8/31/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import UIKit

class PhotoEditingScrollViewDelegate: NSObject, UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        guard let scrollView = scrollView as? PhotoEditingScrollView else {
            return nil
        }

        return scrollView.workspaceView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard let scrollView = scrollView as? PhotoEditingScrollView else {
            return
        }

        scrollView.workspaceView.scrollViewDidZoom(to: scrollView.zoomScale)
    }
}
