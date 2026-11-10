//  Created by Geoff Pado on 11/9/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import DesignSystem
import UIKit

enum SettingsCellConfiguration {
    static let iconCornerRadius = CGFloat(5.6)

    static func content(for row: SettingsModel.Row) -> UIListContentConfiguration {
        var content = UIListContentConfiguration.subtitleCell()
        content.text = row.title
        content.secondaryText = row.subtitle
        content.textProperties.color = .white
        content.secondaryTextProperties.color = .primaryExtraLight
        content.textProperties.adjustsFontForContentSizeCategory = true
        content.secondaryTextProperties.adjustsFontForContentSizeCategory = true

        switch row.style {
        case .standard:
            content.textProperties.font = .appFont(forTextStyle: .subheadline)
            content.secondaryTextProperties.font = .appFont(forTextStyle: .footnote)
        case .purchase:
            content.textProperties.font = .appFont(forTextStyle: .title3)
            content.secondaryTextProperties.font = .appFont(forTextStyle: .subheadline)
            content.secondaryTextProperties.lineBreakMode = .byTruncatingMiddle
            content.secondaryTextProperties.numberOfLines = 1
            content.directionalLayoutMargins.top += 6
            content.directionalLayoutMargins.bottom += 6
        }

        if let iconName = row.iconName {
            content.image = MobileSettingsUIImages(name: iconName).image
            content.imageProperties.cornerRadius = iconCornerRadius
            content.imageProperties.accessibilityIgnoresInvertColors = true
            content.imageToTextPadding = 12
        }

        return content
    }

    static func background(for state: UICellConfigurationState) -> UIBackgroundConfiguration {
        var background = UIBackgroundConfiguration.listGroupedCell()
        background.backgroundColor = (state.isHighlighted || state.isSelected) ? .tableViewCellBackgroundHighlighted : .tableViewCellBackground
        return background
    }

    static func header(title: String?) -> UIListContentConfiguration {
        var content = UIListContentConfiguration.groupedHeader()
        content.text = title
        content.textProperties.font = .appFont(forTextStyle: .footnote)
        content.textProperties.color = .primaryExtraLight
        content.textProperties.transform = .none
        content.textProperties.adjustsFontForContentSizeCategory = true
        return content
    }
}
