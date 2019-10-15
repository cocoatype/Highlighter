//  Created by Geoff Pado on 5/15/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

public class NavigationBar: UINavigationBar {
    public override init(frame: CGRect) {
        super.init(frame: frame)

        barTintColor = .primaryDark
        isTranslucent = false
        tintColor = .white
        titleTextAttributes = [
            .font: UIFont.navigationBarTitleFont,
            .foregroundColor: UIColor.white
        ]

        if #available(iOS 13.0, *) {
            standardAppearance.titleTextAttributes = titleTextAttributes ?? [:]
            standardAppearance.backButtonAppearance.normal.titleTextAttributes = NavigationBar.buttonTitleTextAttributes
            standardAppearance.backButtonAppearance.highlighted.titleTextAttributes = NavigationBar.buttonTitleTextAttributes
            standardAppearance.doneButtonAppearance.normal.titleTextAttributes = NavigationBar.buttonTitleTextAttributes
            standardAppearance.doneButtonAppearance.highlighted.titleTextAttributes = NavigationBar.buttonTitleTextAttributes
        }
    }

    // MARK: Bar Button Appearance

    static let buttonTitleTextAttributes = [
        NSAttributedString.Key.font: UIFont.navigationBarButtonFont
    ]

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
