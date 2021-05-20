//  Created by Geoff Pado on 5/15/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

public class NavigationBar: UINavigationBar {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        tintColor = .white

        if #available(iOS 13.0, *) {
            standardAppearance = NavigationBarAppearance()
            isTranslucent = false
        } else {
            barTintColor = .primaryDark
            isTranslucent = false
            titleTextAttributes = NavigationBar.titleTextAttributes
        }
    }

    // MARK: Bar Button Appearance

    static let largeTitleTextAttributes = [
        NSAttributedString.Key.font: UIFont.navigationBarLargeTitleFont
    ]

    public static let buttonTitleTextAttributes = [
        NSAttributedString.Key.font: UIFont.navigationBarButtonFont
    ]

    public static let titleTextAttributes = [
        NSAttributedString.Key.font: UIFont.navigationBarTitleFont,
        .foregroundColor: UIColor.white
    ]

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

public class NavigationBarAppearance: UINavigationBarAppearance {
    public override init(idiom: UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom) {
        super.init(idiom: idiom)
        configureWithOpaqueBackground()
        backgroundColor = .primaryDark
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
