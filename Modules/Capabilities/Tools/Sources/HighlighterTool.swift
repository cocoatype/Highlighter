//  Created by Geoff Pado on 5/15/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

public enum HighlighterTool: CaseIterable, Equatable, Sendable {
    case magic
    case manual
    case eraser

    public var toolsImage: ToolsImages {
        switch self {
        case .magic: return ToolsAsset.highlighterMagic
        case .manual: return ToolsAsset.highlighterManual
        case .eraser: return ToolsAsset.highlighterEraser
        }
    }

    public var image: UIImage { toolsImage.image }

    public var next: HighlighterTool {
        let index = HighlighterTool.allCases.firstIndex(of: self) ?? 0
        return HighlighterTool.allCases[(index + 1) % HighlighterTool.allCases.count]
    }
}
