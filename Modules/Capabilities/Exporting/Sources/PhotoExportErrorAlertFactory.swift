//  Created by Geoff Pado on 10/14/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import DesignSystem
import UIKit

public enum PhotoExportErrorAlertFactory {
    public static func alert(for error: Error) -> UIAlertController {
        let alert = UIAlertController(
            title: Strings.PhotoExportErrorAlertFactory.title,
            message: Strings.PhotoExportErrorAlertFactory.messageFormat(error.localizedDescription),
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(title: Strings.PhotoExportErrorAlertFactory.dismissButtonTitle, style: .default)
        )
        alert.view.tintColor = .controlTint
        return alert
    }
}
