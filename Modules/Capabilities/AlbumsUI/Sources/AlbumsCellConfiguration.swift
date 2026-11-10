//  Created by Geoff Pado on 11/9/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import AlbumsData
import DesignSystem
import UIKit

enum AlbumsCellConfiguration {
    static func content(for collection: PhotoCollection, state: UICellConfigurationState) -> UIListContentConfiguration {
        var content = UIListContentConfiguration.sidebarCell().updated(for: state)
        content.text = collection.title
        content.textProperties.font = .appFont(forTextStyle: .body)
        content.textProperties.color = .white
        content.textProperties.adjustsFontForContentSizeCategory = true
        content.image = UIImage(systemName: collection.icon)
        content.imageProperties.tintColor = .white
        return content
    }

    static func background(for state: UICellConfigurationState) -> UIBackgroundConfiguration {
        var background = UIBackgroundConfiguration.clear()
        background.cornerRadius = 8
        background.backgroundColor = (state.isSelected || state.isHighlighted) ? .primaryDark : .clear
        return background
    }

    static func header(title: String) -> UIListContentConfiguration {
        var content = UIListContentConfiguration.sidebarHeader()
        content.text = title
        content.textProperties.font = .appFont(forTextStyle: .title3)
        content.textProperties.color = .white
        content.textProperties.transform = .none
        content.textProperties.adjustsFontForContentSizeCategory = true
        return content
    }
}
