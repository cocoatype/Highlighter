//  Created by Geoff Pado on 8/27/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

public class DismissBarButtonItem: UIBarButtonItem {
    private let asset: PHAsset?
    init(asset: PHAsset?) {
        self.asset = asset
        super.init()
        if #available(iOS 26.0, *) {
            self.style = .prominent
            self.tintColor = .clear
        } else {
            self.style = .done
        }
        self.title = EditingToolbarStrings.DismissBarButtonItem.title
        self.target = self
        self.action = #selector(handleButton)
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
