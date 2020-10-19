//  Created by Geoff Pado on 7/1/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Photos
import SwiftUI

@available(iOS 14.0, *)
struct AssetButton: View {
    init(_ asset: PHAsset) { self.init(Asset(asset)) }
    init(_ asset: Asset) {
        self.asset = asset
    }

    @ViewBuilder
    var body: some View {
        GeometryReader { proxy in
            Button(action: { navigationWrapper.presentEditor(for: asset.photoAsset) }) {
                if let image = asset.image {
                    AssetImage(image, size: proxy.size)
                } else {
                    Color.gray
                }
            }
        }
        .buttonStyle(BorderlessButtonStyle())
        .tag(asset.photoAsset.localIdentifier)
    }
    
    @ObservedObject private var asset: Asset
    @EnvironmentObject private var navigationWrapper: NavigationWrapper
}

@available(iOS 14.0, *)
struct AssetButton_Previews: PreviewProvider {
    class PreviewAsset: Asset {
        init() {
            super.init(PHAsset())
        }

        override func fetchImage(completionHandler: @escaping ((UIImage?) -> Void)) {
            let image = UIImage(named: "sample")!
            completionHandler(image)
        }
    }
    static let asset = PreviewAsset()
    static var previews: some View {
        Group {
            AssetButton(asset).frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            AssetButton(asset).frame(width: 60, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
    }
}
