//  Created by Geoff Pado on 7/26/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import UserActivities
import UIKit

@MainActor
public struct SceneDependencyWrangler {
    public init() {}

    public func dependencies(from session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) -> SceneDependencies? {
        if let stateRestorationActivity = session.stateRestorationActivity,
           let activity = EditingUserActivity(userActivity: stateRestorationActivity) {
            return dependencies(from: activity)
        } else if let launchActivity = connectionOptions.userActivities.compactMap(LaunchActivity.init(userActivity:)).first {
            return dependencies(from: launchActivity)
        } else if let editingActivity = connectionOptions.userActivities.compactMap(EditingUserActivity.init(userActivity:)).first {
            return dependencies(from: editingActivity)
        } else if let url = connectionOptions.urlContexts.first?.url {
            return dependencies(from: url)
        } else { return nil }
    }

    private func dependencies(from editingActivity: EditingUserActivity) -> SceneDependencies? {
        return SceneDependencies(
            assetLocalIdentifier: editingActivity.assetLocalIdentifier,
            assetCloudIdentifier: editingActivity.assetCloudIdentifier,
            image: editingActivity.image,
            url: editingActivity.representedURL,
            redactions: editingActivity.redactions
        )

    }

    private func dependencies(from launchActivity: LaunchActivity) -> SceneDependencies? {
        return SceneDependencies(
            assetLocalIdentifier: nil,
            assetCloudIdentifier: nil,
            image: nil,
            url: launchActivity.representedURL,
            redactions: nil
        )
    }

    private func dependencies(from url: URL) -> SceneDependencies? {
        return SceneDependencies(
            assetLocalIdentifier: nil,
            assetCloudIdentifier: nil,
            image: nil,
            url: url,
            redactions: nil
        )
    }
}
