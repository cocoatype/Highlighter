//  Created by Geoff Pado on 6/17/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Defaults
import DesignSystem
import SwiftUI

@available(iOS 15.0, *)
public struct OverlayPreferencesView: View {
    @Binding private var isDetectedTextOverlayEnabled: Bool
    @Binding private var isDetectedCharactersOverlayEnabled: Bool
    @Binding private var isRecognizedTextOverlayEnabled: Bool
    @Binding private var isCalculatedOverlayEnabled: Bool
    @Binding private var isCombinedOverlayEnabled: Bool
    init(defaults: any DefaultsProvider = Defaults.provider) {
        _isDetectedTextOverlayEnabled = Self.binding(for: Keys.showDetectedTextOverlay, in: defaults)
        _isDetectedCharactersOverlayEnabled = Self.binding(for: Keys.showDetectedCharactersOverlay, in: defaults)
        _isRecognizedTextOverlayEnabled = Self.binding(for: Keys.showRecognizedTextOverlay, in: defaults)
        _isCalculatedOverlayEnabled = Self.binding(for: Keys.showCalculatedOverlay, in: defaults)
        _isCombinedOverlayEnabled = Self.binding(for: Keys.showCombinedOverlay, in: defaults)
    }

    public var body: some View {
        List {
            PreferencesCell(isOn: $isDetectedTextOverlayEnabled, title: "Detected Text", color: .red)
            PreferencesCell(isOn: $isDetectedCharactersOverlayEnabled, title: "Detected Characters", color: .blue)
            PreferencesCell(isOn: $isRecognizedTextOverlayEnabled, title: "Recognized Text", color: .yellow)
            PreferencesCell(isOn: $isCalculatedOverlayEnabled, title: "Calculated Area", color: .green)
            PreferencesCell(isOn: $isCombinedOverlayEnabled, title: "Combined Area", color: .purple)
        }
    }

    private struct PreferencesCell: View {
        @Binding var isOn: Bool
        let title: String
        let color: Color

        var body: some View {
            Toggle(isOn: $isOn) {
                Text(title)
            }.tint(color)
        }
    }

    private static func binding(
        for key: Key<Bool>,
        in defaults: any DefaultsProvider
    ) -> Binding<Bool> {
        Binding {
            defaults.value(for: key)
        } set: { newValue in
            defaults.set(newValue, for: key)
        }
    }
}

@available(iOS 15.0, *)
enum OverlayPreferencesViewPreviews: PreviewProvider {
    static var previews: some View {
        OverlayPreferencesView()
    }
}
