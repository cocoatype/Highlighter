//  Created by Geoff Pado on 8/12/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

struct OtherAppItem: SettingsContentItem {
    let appEntry: AppEntry
    let cellIdentifier = SettingsAppEntryTableViewCell.identifier
    var title: String { return appEntry.name }
}
