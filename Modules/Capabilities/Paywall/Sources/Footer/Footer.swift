//  Created by Geoff Pado on 12/2/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import SwiftUI

import FactoryKit

import ErrorHandling
import Purchasing

@available(iOS 16.0, *)
struct Footer: View {
    @State private var viewState: ViewState = .loading
    private let errorHandler: ErrorHandler
    @Injected(\.purchaseRepository) private var purchaseRepository
    init(
        errorHandler: ErrorHandler = ErrorHandler()
    ) {
        self.errorHandler = errorHandler
    }

    var body: some View {
        currentView
            .task { await updateProducts() }
    }

    private func updateProducts() async {
        do {
            let products = try await purchaseRepository.products
            let options = await withTaskGroup(of: PaywallOption.self) { group in
                for product in products {
                    group.addTask {
                        return await PaywallOption(product: product)
                    }
                }

                var options = [PaywallOption]()
                for await option in group {
                    options.append(option)
                }
                return options
            }
            viewState = .unpurchased(options)
        } catch {
            errorHandler.log(error)
        }
    }

    @ViewBuilder private var currentView: some View {
        switch viewState {
        case .loading:
            ProgressView()
        case .unpurchased(let options):
            FooterContents(options: options)
        }
    }

    enum ViewState {
        case loading
        case unpurchased([PaywallOption])
    }
}

#if DEBUG
@available(iOS 16.0, *)
#Preview {
    Color.black
        .ignoresSafeArea()
        .safeAreaInset(edge: .bottom) {
            Footer()
                .background(ignoresSafeAreaEdges: .bottom)
        }
}
#endif
