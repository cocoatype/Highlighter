//  Created by Geoff Pado on 5/15/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

public class Toolbar: UIToolbar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        isTranslucent = false
        tintColor = .white

        standardAppearance = ToolbarAppearance()
        compactAppearance = ToolbarAppearance()

        if #available(iOS 15.0, *) {
            scrollEdgeAppearance = ToolbarAppearance()
            compactScrollEdgeAppearance = ToolbarAppearance()
        }
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

public class ToolbarAppearance: UIToolbarAppearance {
    public override init(idiom: UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom) {
        super.init(idiom: idiom)
        configureWithOpaqueBackground()
        backgroundColor = .primaryDark
        doneButtonAppearance.normal.titleTextAttributes = NavigationBar.buttonTitleTextAttributes
        doneButtonAppearance.highlighted.titleTextAttributes = NavigationBar.buttonTitleTextAttributes
        buttonAppearance.normal.titleTextAttributes = NavigationBar.buttonTitleTextAttributes
        buttonAppearance.highlighted.titleTextAttributes = NavigationBar.buttonTitleTextAttributes
    }

    public override init(barAppearance: UIBarAppearance) {
        super.init(barAppearance: barAppearance)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
