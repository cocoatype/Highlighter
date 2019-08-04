//  Created by Geoff Pado on 8/4/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PageCountAlertFactory: NSObject {
    static func alert(completionHandler: @escaping (() -> Void)) -> UIAlertController {
        let alertController = UIAlertController(title: PageCountAlertFactory.alertTitle, message: PageCountAlertFactory.alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: PageCountAlertFactory.dismissButtonTitle, style: .default) { _ in
            completionHandler()
        })

        return alertController
    }

    // MARK: Localized Strings
    private static let alertTitle = NSLocalizedString("PageCountAlertFactory.alertTitle", comment: "Title for the page count alert when scanning documents")
    private static let alertMessage = NSLocalizedString("PageCountAlertFactory.alertMessage", comment: "Message for the page count alert when scanning documents")
    private static let dismissButtonTitle = NSLocalizedString("PageCountAlertFactory.dismissButtonTitle", comment: "Title for the dismiss button on the page count alert when scanning documents")
}
