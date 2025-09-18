//  Created by Geoff Pado on 3/28/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Tools
import UIKit

@MainActor
class HighlighterToolBarButtonItem: UIBarButtonItem {
    convenience init(tool: HighlighterTool, target: AnyObject?) {
        self.init(title: Self.buttonTitle, image: tool.image)

        menu = UIMenu(
            image: HighlighterTool.magic.image,
            children: HighlighterTool.allCases.map { tool -> UIAction in
                let event = HighlighterToolSelectionEvent(tool: tool)
                let selector = #selector(ToolbarActions.selectHighlighterTool(_:event:))
                return UIAction(title: Self.title(for: tool), image: tool.image) { [weak self] _ in
                    guard let responder = self?.target as? UIResponder else { return }
                    let actionTarget = responder.target(forAction: selector, withSender: responder) as? UIResponder
                    actionTarget?.perform(selector, with: responder, with: event)
                }
            }
        )
        self.target = target

        accessibilityValue = Self.title(for: tool)
    }

    private static func title(for tool: HighlighterTool) -> String {
        switch tool {
        case .magic: return Strings.HighlighterToolBarButtonItem.magicToolItem
        case .lasso: return Strings.HighlighterToolBarButtonItem.lassoToolItem
        case .manual: return Strings.HighlighterToolBarButtonItem.manualToolItem
        case .eraser: return Strings.HighlighterToolBarButtonItem.eraserToolItem
        }
    }

    private static let buttonTitle = Strings.HighlighterToolBarButtonItem.buttonTitle
}
