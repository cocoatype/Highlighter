//  Created by Geoff Pado on 7/29/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation

protocol PhotoEditingBrushStrokeView {
    var currentPath: UIBezierPath? { get }
    func updateTool(currentZoomScale: CGFloat)
}
