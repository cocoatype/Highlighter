//  Created by Geoff Pado on 3/31/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Photos
import XCTest
@testable import Highlighter

class IntroViewControllerTests: XCTestCase {
    func testDisplayingDeniedAlert() {
        let permissionsRequester = MockPhotoPermissionsRequester(desiredAuthorizationStatus: .denied)
        let viewController = PresentationExpectationMockIntroViewController(permissionsRequester: permissionsRequester)
        viewController.presentedViewControllerExpectedType = PhotoPermissionsDeniedAlertController.self
        viewController.presentationExpectation = expectation(description: "denied alert is shown")
        viewController.requestPermission()

        waitForExpectations(timeout: 1)
    }

    func testDisplayingRestrictedAlert() {
        let permissionsRequester = MockPhotoPermissionsRequester(desiredAuthorizationStatus: .restricted)
        let viewController = PresentationExpectationMockIntroViewController(permissionsRequester: permissionsRequester)
        viewController.presentedViewControllerExpectedType = PhotoPermissionsRestrictedAlertController.self
        viewController.presentationExpectation = expectation(description: "restricted alert is shown")
        viewController.requestPermission()

        waitForExpectations(timeout: 1)
    }

    class MockPhotoPermissionsRequester: PhotoPermissionsRequester {
        init(desiredAuthorizationStatus: PHAuthorizationStatus) {
            self.authorizationStatus = desiredAuthorizationStatus
            super.init()
        }

        var authorizationStatus: PHAuthorizationStatus
        override func requestAuthorization(_ handler: @escaping (PHAuthorizationStatus) -> Void) {
            handler(authorizationStatus)
        }
    }

    class PresentationExpectationMockIntroViewController: IntroViewController {
        var presentedViewControllerExpectedType: UIViewController.Type?
        var presentationExpectation: XCTestExpectation?
        override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
            guard let expectedType = presentedViewControllerExpectedType else { return }
            if viewControllerToPresent.isKind(of: expectedType) {
                presentationExpectation?.fulfill()
            }
        }
    }
}

