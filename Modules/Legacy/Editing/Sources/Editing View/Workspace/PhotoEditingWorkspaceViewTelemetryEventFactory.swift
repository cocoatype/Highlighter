//  Created by Geoff Pado on 12/5/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Logging
import Tools
import UIKit

struct PhotoEditingWorkspaceViewTelemetryEventFactory {
    private static let eventName = Event.Name("PhotoEditingWorkspaceView.strokeCompleted")
    private static let toolKey = "tool"
    private static let colorKey = "color"
    func event(tool: HighlighterTool, color: UIColor) -> Event {
        var info = [Self.toolKey: value(for: tool)]
        if tool.logsColor {
            info[Self.colorKey] = value(for: color)
        }

        return Event(name: Self.eventName, info: info)
    }

    private func value(for tool: HighlighterTool) -> String {
        switch tool {
        case .magic: "magic"
        case .lasso: "lasso"
        case .manual: "manual"
        case .eraser: "eraser"
        }
    }

    private func value(for color: UIColor) -> String {
        color.hexString
    }
}

fileprivate extension HighlighterTool {
    var logsColor: Bool {
        switch self {
        case .magic, .lasso, .manual: true
        case .eraser: false
        }
    }
}

fileprivate extension UIColor {
    var hexString: String {
        var red = CGFloat.zero
        var green = CGFloat.zero
        var blue = CGFloat.zero
        getRed(&red, green: &green, blue: &blue, alpha: nil)

        let redInt = Int(round(red * 255))
        let greenInt = Int(round(green * 255))
        let blueInt = Int(round(blue * 255))

        return String(format: "#%02x%02x%02x", redInt, greenInt, blueInt)
    }
}
