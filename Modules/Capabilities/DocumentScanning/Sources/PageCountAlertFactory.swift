//  Created by Geoff Pado on 8/4/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

import DesignSystem

@MainActor class PageCountAlertFactory: NSObject {
    static func alert(completionHandler: @escaping (@MainActor () -> Void)) -> UIAlertController {
        let alertController = UIAlertController(title: Strings.alertTitle, message: Strings.alertMessage, preferredStyle: .alert)
        alertController.view.tintColor = .controlTint
        alertController.addAction(UIAlertAction(title: Strings.dismissButtonTitle, style: .default) { _ in
            completionHandler()
        })

        return alertController
    }

    typealias Strings = DocumentScanningStrings.PageCountAlertFactory
}
