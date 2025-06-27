//  Created by Geoff Pado on 11/30/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import AppIntents
import DesignSystem
import UIKit

@available(iOS 16.0, *)
struct ColorEntity: AppEntity, RawRepresentable, Identifiable, ExpressibleByIntegerLiteral {
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "ColorEntity.TypeDisplayRepresentation"

    static let black = ColorEntity(color: .black)
    static let white = ColorEntity(color: .white)
    static let gray = ColorEntity(color: .systemGray)
    static let red = ColorEntity(color: .systemRed)
    static let orange = ColorEntity(color: .systemOrange)
    static let yellow = ColorEntity(color: .systemYellow)
    static let green = ColorEntity(color: .systemGreen)
    static let blue = ColorEntity(color: .systemBlue)
    static let purple = ColorEntity(color: .systemPurple)

    var color: UIColor
    init(color: UIColor) {
        self.color = color
    }

    init?(rawValue: String) {
        guard let color = UIColor(hexString: rawValue) else { return nil }
        self.init(color: color)
    }

    var rawValue: String { color.hexString }

    init(integerLiteral value: Int) {
        self.init(color: UIColor(hexLiteral: value))
    }

    private var colorName: String {
        let baseName = switch color {
        case .black: String(localized: "ColorEntity.colorName.black", bundle: .module)
        case .white: String(localized: "ColorEntity.colorName.white", bundle: .module)
        case .systemGray: String(localized: "ColorEntity.colorName.systemGray", bundle: .module)
        case .systemRed: String(localized: "ColorEntity.colorName.systemRed", bundle: .module)
        case .systemOrange: String(localized: "ColorEntity.colorName.systemOrange", bundle: .module)
        case .systemYellow: String(localized: "ColorEntity.colorName.systemYellow", bundle: .module)
        case .systemGreen: String(localized: "ColorEntity.colorName.systemGreen", bundle: .module)
        case .systemBlue: String(localized: "ColorEntity.colorName.systemBlue", bundle: .module)
        case .systemPurple: String(localized: "ColorEntity.colorName.systemPurple", bundle: .module)
        default: color.accessibilityName
        }

        return baseName.capitalized
    }

    private static let renderer = ColorRenderer()
    var displayRepresentation: DisplayRepresentation {
        let title: String.LocalizationValue = "ColorEntity.displayRepresentation.title\(colorName)"
        let titleResource = LocalizedStringResource(title, bundle: .atURL(Bundle.module.bundleURL))
        let image = try? DisplayRepresentation.Image(data: Self.renderer.data(for: color))

        return DisplayRepresentation(title: titleResource, image: image)
    }

    public static let defaultQuery = ColorQuery()
}
