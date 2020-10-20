//  Created by Geoff Pado on 10/7/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Foundation

class ColorPanel: NSObject {
    private static let _shared: ColorPanel = {
        guard let underlyingPanel = NSClassFromString("NSColorPanel")?.value(forKeyPath: "sharedColorPanel") as AnyObject? else { fatalError("Unable to create color panel") }
        return ColorPanel(underlyingPanel)
    }()
    static var shared: ColorPanel { return _shared }

    @objc(makeKeyAndOrderFront:)
    func makeKeyAndOrderFront(_ sender: Any) {
        _ = underlyingPanel.perform(#selector(ColorPanel.makeKeyAndOrderFront(_:)), with: sender)
    }

    var color: UIColor {
        get {
            guard let value = underlyingPanel.value(forKeyPath: "color"),
                  let color = value as? UIColor else { return .black }
            return color
        }

        set(newColor) {
            underlyingPanel.setValue(newColor, forKey: "color")
        }
    }

    // MARK: Boilerplate

    static let colorDidChangeNotification = Notification.Name("ColorPanel.colorDidChangeNotification")
    private static let underlyingPanelDidChangeNotification = Notification.Name("NSColorPanelColorDidChangeNotification")

    private var colorObserver: Any?
    private let underlyingPanel: AnyObject
    private override init() { fatalError("Cannot create ColorPanel without underlying panel") }

    private init(_ underlyingPanel: AnyObject) {
        self.underlyingPanel = underlyingPanel
        super.init()

        colorObserver = NotificationCenter.default.addObserver(forName: Self.underlyingPanelDidChangeNotification, object: nil, queue: nil, using: { [weak self] _ in
            NotificationCenter.default.post(name: Self.colorDidChangeNotification, object: self)
        })
    }

    deinit {
        colorObserver.map(NotificationCenter.default.removeObserver(_:))
    }
}
