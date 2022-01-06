//  Created by Geoff Pado on 1/5/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import UIKit

#if targetEnvironment(macCatalyst)
class NewFromClipboardCommand: UIKeyCommand {
    override convenience init() {
        self.init(title: NewFromClipboardCommand.title, action: #selector(AppDelegate.newSceneFromClipboard), input: "N", modifierFlags: [.command, .alternate])
    }

    private static let title = NSLocalizedString("NewFromClipboardCommand.title", comment: "Title for the 'new from clipboard' keyboard command")
}
#endif
