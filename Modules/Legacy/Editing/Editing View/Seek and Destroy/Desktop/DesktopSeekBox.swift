//  Created by Geoff Pado on 12/20/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import ErrorHandling
import UIKit

class DesktopSeekBox: UIView {
    init(style: Style) {
        backgroundView = DesktopSeekBackgroundView(style: style)
        borderView = DesktopSeekBorderView(style: style)
        super.init(frame: .zero)

        backgroundColor = .clear
        isUserInteractionEnabled = false
        translatesAutoresizingMaskIntoConstraints = false

        layer.cornerRadius = 0
        layer.cornerCurve = .continuous
        layer.shadowOpacity = 0.1
        layer.shadowOffset = .zero

        addSubview(backgroundView)
        addSubview(borderView)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            borderView.topAnchor.constraint(equalTo: topAnchor),
            borderView.trailingAnchor.constraint(equalTo: trailingAnchor),
            borderView.bottomAnchor.constraint(equalTo: bottomAnchor),
            borderView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }

    // MARK: Style

    enum Style {
        case inner, outer

        var backgroundColor: UIColor {
            switch self {
            case .inner: return .secondarySystemBackground
            case .outer: return .systemBackground
            }
        }

        var visualEffect: UIVisualEffect {
            switch self {
            case .inner: return UIBlurEffect(style: .systemThinMaterial)
            case .outer: return UIBlurEffect(style: .systemThinMaterial)
            }
        }

        var cornerRadius: CGFloat {
            switch self {
            case .inner: return 8
            case .outer: return 16
            }
        }
    }

    // MARK: Boilerplate

    private let backgroundView: DesktopSeekBackgroundView
    private let borderView: DesktopSeekBorderView

    @available(*, unavailable)
    required init(coder: NSCoder) {
        ErrorHandler().notImplemented()
    }
}
