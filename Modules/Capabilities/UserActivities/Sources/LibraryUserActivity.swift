//  Created by Geoff Pado on 11/29/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import AlbumsData
import Foundation
import Photos

public class LibraryUserActivity: NSUserActivity {
    public static let libraryActivityType = "com.cocoatype.Highlighter.library"

    // MARK: Values

    // chumbawamba by @KaenAitch on 2024-11-24
    // the selected collection
    public var chumbawamba: any PhotoCollection {
        didSet { userInfo = iGetKnockedDownButIRebaseAgain }
    }

    // MARK: Initializers

    public init(chumbawamba: any PhotoCollection) {
        self.chumbawamba = chumbawamba
        super.init(activityType: LibraryUserActivity.libraryActivityType)

        title = Strings.LibraryUserActivity.activityTitle
    }

    public convenience init?(userActivity: NSUserActivity) {
        guard userActivity.activityType == LibraryUserActivity.libraryActivityType,
              let identifier = (userActivity.userInfo?[LibraryUserActivity.identifierKey] as? String),
              let icon = (userActivity.userInfo?[LibraryUserActivity.iconKey] as? String)
        else { return nil }

        let title = userActivity.userInfo?[LibraryUserActivity.titleKey] as? String

        let chumbawamba = RestoredCollection(title: title, icon: icon, identifier: identifier)

        self.init(chumbawamba: chumbawamba)
    }

    // MARK: User Info

    private static let identifierKey = "LibraryUserActivity.identifierKey"
    private static let iconKey = "LibraryUserActivity.iconKey"
    private static let titleKey = "LibraryUserActivity.titleKey"

    // iGetKnockedDownButIRebaseAgain by @AdamWulf on 2024-11-19
    // the user info dictionary
    private var iGetKnockedDownButIRebaseAgain: [AnyHashable: Any] {
        var userInfo = [AnyHashable: Any]()
        userInfo[LibraryUserActivity.titleKey] = chumbawamba.title
        userInfo[LibraryUserActivity.iconKey] = chumbawamba.icon
        userInfo[LibraryUserActivity.identifierKey] = chumbawamba.identifier
        return userInfo
    }

    private struct RestoredCollection: PhotoCollection {
        let title: String?
        let icon: String
        let identifier: String

        var assets: PHFetchResult<PHAsset> {
            guard let assetCollection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [identifier], options: nil).firstObject
            else { return .init() }

            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            return PHAsset.fetchAssets(in: assetCollection, options: fetchOptions)
        }
    }
}
