//  Created by Geoff Pado on 8/27/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

public class DismissBarButtonItem: UIBarButtonItem {
    private let asset: PHAsset?
    init(asset: PHAsset?) {
        self.asset = asset
        super.init()
        self.style = .done
        self.title = Strings.DismissBarButtonItem.title
        self.target = self
        self.action = #selector(handleButton)

        if #available(iOS 26.0, *) {
            self.tintColor = .clear
        }
    }

    @objc private func handleButton() {
        let event = Event(asset: asset)
        UIApplication.shared.sendAction(
            #selector(ToolbarActions.dismissPhotoEditingViewController),
            to: nil,
            from: self,
            for: event
        )
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }

    public class Event: UIEvent {
        public let asset: PHAsset?
        init(asset: PHAsset?) {
            self.asset = asset
            super.init()
        }
    }
}
