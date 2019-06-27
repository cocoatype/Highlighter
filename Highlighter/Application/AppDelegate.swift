//  Created by Geoff Pado on 3/31/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = AppWindow()
        window.rootViewController = AppViewController()
        window.makeKeyAndVisible()
        self.window = window

        return true
    }

    // MARK: URL Handling

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let action = CallbackAction(url: url) {
            return handleCallbackAction(action)
        } else {
            return openFile(at: url)
        }
    }

    private func handleCallbackAction(_ action: CallbackAction) -> Bool {
        guard let appViewController = appViewController else { return false }
        switch action {
        case .open(let image): appViewController.presentPhotoEditingViewController(for: image)
        case .edit(let image, let successURL):
            appViewController.presentPhotoEditingViewController(for: image) { editedImage in
                guard let successURL = successURL,
                  var callbackURLComponents = URLComponents(url: successURL, resolvingAgainstBaseURL: true),
                  let imageData = image.pngData(),
                  let imageEncodedString = imageData.base64EncodedString().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                else { return }

                callbackURLComponents.queryItems = [URLQueryItem(name: "imageData", value: imageEncodedString)]

                guard let callbackURL = callbackURLComponents.url else { return }
                UIApplication.shared.open(callbackURL)
            }
        }

        return true
    }

    private func openFile(at url: URL) -> Bool {
        guard let appViewController = appViewController else { return false }

        do {
            let imageData = try Data(contentsOf: url)
            guard let image = UIImage(data: imageData) else { return false }

            appViewController.presentPhotoEditingViewController(for: image)
            return true
        } catch {
            return false
        }
    }

    // MARK: Boilerplate
    private var appViewController: AppViewController? { return window?.rootViewController as? AppViewController }
}
