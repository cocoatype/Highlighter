//  Created by Geoff Pado on 5/18/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation

enum AppLookupResponseResult: Decodable {
    case developerInfo(AppDeveloperInfo)
    case appEntry(AppEntry)
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let appEntry = try? container.decode(AppEntry.self) {
            self = .appEntry(appEntry)
        } else if let developerInfo = try? container.decode(AppDeveloperInfo.self) {
            self = .developerInfo(developerInfo)
        } else {
            self = .unknown
        }
    }
}
