//  Created by Geoff Pado on 7/10/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

import FactoryKit

import ErrorHandling
import ImageOpening
import Logging
import URLParsing

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    var window: AppWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        let window = AppWindow(windowScene: scene)
        window.makeKeyAndVisible()
        self.window = window

        guard handle(connectionOptions.urlContexts) else {
            let restorationActivity = session.stateRestorationActivity
            let dragActivity = connectionOptions.userActivities.first

            if let userActivity = restorationActivity ?? dragActivity {
                window.restore(from: userActivity)
            }

            return
        }
    }

    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        window?.stateRestorationActivity
    }

    func scene(_ scene: UIScene, openURLContexts urlContexts: Set<UIOpenURLContext>) {
        handle(urlContexts)
    }

    @discardableResult
    private func handle(_ urlContexts: Set<UIOpenURLContext>) -> Bool {
        guard let url = urlContexts.first?.url else { return false }
        return switch URLParser().parse(url) {
        case .callbackAction(let action):
            handleCallbackAction(action)
        case .image(let imageURL):
            openImage(at: imageURL)
        case .website(let webURL):
            openWebPage(webURL)
        case .invalid:
            false
        }
    }

    private func handleCallbackAction(_ action: CallbackAction) -> Bool {
        guard let appViewController else { return false }
        switch action {
        case .open(let image):
            logger.log(EventFactory().editorPresentationEvent(for: .xCallbackURL))
            appViewController.presentPhotoEditingViewController(for: image, animated: false)
        case .edit(let image, let successURL):
            logger.log(EventFactory().editorPresentationEvent(for: .xCallbackURL))
            appViewController.presentPhotoEditingViewController(for: image, animated: false) { editedImage in
                guard let successURL = successURL,
                  var callbackURLComponents = URLComponents(url: successURL, resolvingAgainstBaseURL: true),
                  let imageData = editedImage.pngData(),
                  let imageEncodedString = imageData.base64EncodedString().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                else { return }

                callbackURLComponents.queryItems = [URLQueryItem(name: "imageData", value: imageEncodedString)]

                guard let callbackURL = callbackURLComponents.url else { return }
                UIApplication.shared.open(callbackURL)
            }
        }

        return true
    }

    private func openImage(at imageURL: URL) -> Bool {
        guard let appViewController else { return false }
        do {
            let image = try ImageOpener().openImage(at: imageURL)
            logger.log(EventFactory().editorPresentationEvent(for: .fileURL))
            appViewController.presentPhotoEditingViewController(for: image, animated: false)
            return true
        } catch {
            errorHandler.log(error, module: "Core", type: "SceneDelegate")
            return false
        }
    }

    private func openWebPage(_ webURL: URL) -> Bool {
        guard let appViewController else { return false }
        appViewController.presentWebView(for: webURL)
        return true
    }

    private var appViewController: AppViewController? { return window?.rootViewController as? AppViewController }
    @Injected(\.errorHandler) private var errorHandler
    @Injected(\.logger) private var logger
}
