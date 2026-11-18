//  Created by Geoff Pado on 8/5/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

@MainActor @objc public protocol DocumentScannerPresenting {
    func presentDocumentCameraViewController()
}

extension UIResponder {
    public var documentScannerPresenter: any DocumentScannerPresenting? {
        if let presenter = (self as? any DocumentScannerPresenting) {
            return presenter
        }

        return next?.documentScannerPresenter
    }
}
