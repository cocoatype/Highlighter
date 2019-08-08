//  Created by Geoff Pado on 8/5/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

@available(iOS 13.0, *)
protocol DocumentScannerPresenting {
    func presentDocumentCameraViewController()
}

@available(iOS 13.0, *)
extension UIResponder {
    var documentScannerPresenter: DocumentScannerPresenting? {
        if let presenter = (self as? DocumentScannerPresenting) {
            return presenter
        }

        return next?.documentScannerPresenter
    }
}
