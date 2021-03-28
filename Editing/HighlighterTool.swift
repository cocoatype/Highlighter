//  Created by Geoff Pado on 5/15/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

public enum HighlighterTool: CaseIterable {
    case magic
    case manual
    case eraser

    public var image: UIImage? {
        if #available(iOS 14.0, *) {
            switch self {
            case .magic: return UIImage(named: "highlighter.magic")
            case .manual: return UIImage(systemName: "highlighter")
            case .eraser: return UIImage(named: "highlighter.eraser")
            }
        } else {
            switch self {
            case .magic: return #imageLiteral(resourceName: "Magic Highlighter")
            case .manual: return #imageLiteral(resourceName: "Standard Highlighter.png")
            case .eraser: return UIImage(named: "highlighter.eraser")
            }
        }
    }
}
