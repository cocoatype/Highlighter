//  Created by Geoff Pado on 7/1/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Editing
import Photos
import SwiftUI

@available(iOS 14.0, *)
struct PhotoLibraryView: View {
    var navigationWrapper = NavigationWrapper.empty
    init(dataSource: LibraryDataSource) {
        self.dataSource = dataSource
    }

    var body: some View {
        PhotoLibraryScrollView(dataSource: dataSource)
            .background(Color.appPrimary.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: SettingsButton())
            .environmentObject(navigationWrapper)
    }

    // MARK: Boilerplate
    
    private var dataSource: LibraryDataSource
}

@available(iOS 14.0, *)
struct PhotoLibraryView_Previews: PreviewProvider {
    struct PreviewLibraryDataSource: LibraryDataSource {
        var itemsCount: Int { 10 }
        func item(at index: Int) -> PhotoLibraryItem {
            if index < itemsCount - 1 { return .asset(PHAsset()) }
            return .documentScan
        }
    }

    static var previews: some View {
        PhotoLibraryView(dataSource: PreviewLibraryDataSource())
    }
}
