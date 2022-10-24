//  Created by Geoff Pado on 10/14/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import UIKit

public enum PhotoExportErrorAlertFactory {
    public static func alert(for error: Error) -> UIAlertController {
        let alert = UIAlertController(title: Self.title, message: String(format: messageFormat, error.localizedDescription), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Self.dismissButtonTitle, style: .default))
        alert.view.tintColor = .controlTint
        return alert
    }

    private static let title = NSLocalizedString("PhotoExportErrorAlertFactory.title", comment: "Title for the alert when exporting fails")
    private static let messageFormat = NSLocalizedString("PhotoExportErrorAlertFactory.messageFormat", comment: "Message for the alert when exporting fails")
    private static let dismissButtonTitle = NSLocalizedString("PhotoExportErrorAlertFactory.dismissButtonTitle", comment: "Dismiss button title for the alert when exporting fails")
}
