//  Created by Geoff Pado on 8/12/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

protocol StandardContentItem: SettingsContentItem {}

extension StandardContentItem {
    var cellIdentifier: String { return SettingsStandardTableViewCell.identifier }
}
