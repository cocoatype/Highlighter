//  Created by Geoff Pado on 8/27/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import UIKit

class ColorPickerBarButtonItem: UIBarButtonItem {
    convenience init(target: AnyObject?) {
        self.init(image: UIImage(systemName: "paintpalette"), style: .plain, target: target, action: #selector(ActionsBuilderActions.showColorPicker(_:)))
    }
}
