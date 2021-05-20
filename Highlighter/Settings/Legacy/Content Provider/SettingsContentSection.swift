//  Created by Geoff Pado on 8/12/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

protocol SettingsContentSection {
    var header: String? { get }
    var items: [SettingsContentItem] { get }
}
