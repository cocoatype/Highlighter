//  Created by Geoff Pado on 3/28/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import UIKit

class LegacyHighlighterToolBarButtonItem: UIBarButtonItem {
    convenience init(tool: HighlighterTool, target: AnyObject?) {
        self.init(image: tool.image, style: .plain, target: target, action: #selector(ActionsBuilderActions.toggleHighlighterTool(_:)))
    }
}
