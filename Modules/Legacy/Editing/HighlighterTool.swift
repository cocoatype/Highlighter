//  Created by Geoff Pado on 5/15/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

public enum HighlighterTool: CaseIterable {
    case magic
    case manual
    case eraser

    public var image: UIImage? {
        switch self {
        case .magic: return UIImage(named: "highlighter.magic")
        case .manual: return UIImage(named: "highlighter.manual")
        case .eraser: return UIImage(named: "highlighter.eraser")
        }
    }
}
