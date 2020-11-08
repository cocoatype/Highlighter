//  Created by Geoff Pado on 10/12/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Combine
import SwiftUI

@available(iOS 14.0, *)
struct PhotoLibraryScrollView: View {
    init(dataSource: PhotoLibraryDataSource) {
        self.dataSource = dataSource
        self._itemsCount = State(initialValue: dataSource.itemsCount)
    }

    @ViewBuilder
    private func itemView(for item: PhotoLibraryItem) -> some View {
        switch item {
        case .asset(let asset): AssetButton(asset)
        case .documentScan: DocumentScanButton()
        case .limitedLibrary: LimitedLibraryButton()
        }
    }

    private let gridItem: GridItem = {
        var item = GridItem(.adaptive(minimum: 126, maximum: .infinity))
        item.spacing = 1
        return item
    }()

    var body: some View {
        ScrollView {
            ScrollViewReader { proxy in
                LazyVGrid(columns: [gridItem, gridItem, gridItem, gridItem], spacing: 1) {
                    ForEach((0..<itemsCount), id: \.self) {
                        itemView(for: dataSource.item(at: $0)).aspectRatio(contentMode: .fill)
                    }
                }.onAppear {
                    guard shouldScrollToBottom else { return }
                    proxy.scrollTo(dataSource.itemsCount - 1, anchor: .bottom)

                    shouldScrollToBottom = false
                }.onReceive(dataSource.itemsCountPublisher) { itemsCount in
                    self.itemsCount = itemsCount
                }
            }
        }
    }

    // MARK: Boilerplate

    private var dataSource: PhotoLibraryDataSource
    @State private var shouldScrollToBottom = true
    @State private var itemsCount: Int
}
