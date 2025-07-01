//  Created by Geoff Pado on 5/11/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Defaults
import Logging
import SwiftUI

public struct UnpurchasedAlertViewModifier: ViewModifier {
    @Binding private var isPresented: Bool
    private let feature: UnpurchasedFeature
    private let defaults: any DefaultsProvider
    private let logger: any Logger
    init(
        for feature: UnpurchasedFeature,
        isPresented: Binding<Bool>,
        defaults: any DefaultsProvider = Defaults.provider,
        logger: any Logger = Logging.logger
    ) {
        _isPresented = isPresented
        self.feature = feature
        self.defaults = defaults
        self.logger = logger
    }

    public func body(content: Content) -> some View {
        content.alert(isPresented: $isPresented) {
            if let hideFeatureKey = feature.hideFeatureKey {
                return Alert(
                    title: Text(Strings.title),
                    message: Text(feature.message),
                    primaryButton: .cancel(Text(Strings.dismissButton)),
                    secondaryButton: .default(Text(Strings.hideButton)) {
                        defaults.set(true, for: hideFeatureKey)
                    }
                )
            } else {
                return Alert(
                    title: Text(Strings.title),
                    message: Text(feature.message),
                    dismissButton: .cancel(Text(Strings.dismissButton))
                )
            }
        }.onChange(of: isPresented) { newValue in
            if newValue {
                logger.log(Event(name: "UnpurchasedAlertViewModifier.isPresented"))
            }
        }
    }

    private typealias Strings = UnpurchasedStrings.UnpurchasedAlert
}

public extension View {
    func unpurchasedAlert(for feature: UnpurchasedFeature, isPresented: Binding<Bool>) -> ModifiedContent<Self, UnpurchasedAlertViewModifier> {
        modifier(UnpurchasedAlertViewModifier(for: feature, isPresented: isPresented))
    }
}
