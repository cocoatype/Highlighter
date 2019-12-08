//  Created by Geoff Pado on 5/15/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

public class NavigationBar: UINavigationBar {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        tintColor = .white

        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .primaryDark
            appearance.titleTextAttributes = NavigationBar.titleTextAttributes
            appearance.backButtonAppearance.normal.titleTextAttributes = NavigationBar.buttonTitleTextAttributes
            appearance.backButtonAppearance.highlighted.titleTextAttributes = NavigationBar.buttonTitleTextAttributes
            appearance.doneButtonAppearance.normal.titleTextAttributes = NavigationBar.buttonTitleTextAttributes
            appearance.doneButtonAppearance.highlighted.titleTextAttributes = NavigationBar.buttonTitleTextAttributes
            appearance.doneButtonAppearance.normal.titleTextAttributes = NavigationBar.buttonTitleTextAttributes
            appearance.doneButtonAppearance.highlighted.titleTextAttributes = NavigationBar.buttonTitleTextAttributes
            standardAppearance = appearance
        } else {
            barTintColor = .primaryDark
            isTranslucent = false
            titleTextAttributes = NavigationBar.titleTextAttributes
        }
    }

    // MARK: Bar Button Appearance

    static let buttonTitleTextAttributes = [
        NSAttributedString.Key.font: UIFont.navigationBarButtonFont
    ]

    static let titleTextAttributes = [
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
