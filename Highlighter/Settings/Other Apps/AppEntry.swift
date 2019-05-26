//  Created by Geoff Pado on 5/18/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation

struct AppEntry: Codable, Equatable {
    var bundleID: String { return bundleId }
    var name: String { return trackName }
    var appStoreURL: URL? { return URL(string: trackViewUrl) }
    var iconURL: URL? { return URL(string: artworkUrl100) }

    private let artworkUrl100: String
    private let bundleId: String
    private let trackName: String
    private let trackViewUrl: String

    static func == (lhs: AppEntry, rhs: AppEntry) -> Bool {
        return lhs.bundleID == rhs.bundleID
    }
}
