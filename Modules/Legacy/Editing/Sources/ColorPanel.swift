//  Created by Geoff Pado on 10/7/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

#if canImport(UIKit)
import UIKit

import FactoryKit

import ErrorHandling

@MainActor
class ColorPanel: NSObject {
    private static let _shared: ColorPanel = {
        guard let underlyingPanel = NSClassFromString("NSColorPanel")?
            .value(forKeyPath: "sharedColorPanel") as AnyObject?
        else {
            Container.shared.errorHandler()
                .crash("Unable to create color panel")
        }
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

    private let underlyingPanel: AnyObject
    private override init() {
        Container.shared.errorHandler()
            .crash("Cannot create ColorPanel without underlying panel")
    }

    private init(_ underlyingPanel: AnyObject) {
        self.underlyingPanel = underlyingPanel
        super.init()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(underlyingPanelColorDidChange),
            name: Self.underlyingPanelDidChangeNotification,
            object: nil
        )
    }

    @objc private func underlyingPanelColorDidChange() {
        NotificationCenter.default.post(name: Self.colorDidChangeNotification, object: self)
    }
}
#endif
