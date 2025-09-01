//  Created by Geoff Pado on 5/11/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import UIKit

public class NavigationBarAppearance: UINavigationBarAppearance {
    public override init(idiom: UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom) {
        super.init(idiom: idiom)

        if #available(iOS 26.0, *) {
            configureWithTransparentBackground()
            backgroundColor = .clear
        } else {
            configureWithOpaqueBackground()
            backgroundColor = .primaryDark
        }

        largeTitleTextAttributes = NavigationBar.largeTitleTextAttributes
        titleTextAttributes = NavigationBar.titleTextAttributes
        backButtonAppearance.normal.titleTextAttributes = NavigationBar.buttonTitleTextAttributes
        backButtonAppearance.highlighted.titleTextAttributes = NavigationBar.buttonTitleTextAttributes
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
