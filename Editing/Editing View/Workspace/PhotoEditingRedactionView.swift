//  Created by Geoff Pado on 5/6/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

public class PhotoEditingRedactionView: UIView {
    public init() {
        super.init(frame: .zero)

        backgroundColor = .clear
        isOpaque = false
        translatesAutoresizingMaskIntoConstraints = false
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)

        redactions
          .flatMap { $0.paths }
          .map { $0.dashedPath }
          .forEach { path in
            let brushStampImage = brushStamp(scaledToHeight: path.lineWidth)
            path.forEachPoint{ point in
                guard let context = UIGraphicsGetCurrentContext() else { return }
                context.saveGState()
                defer { context.restoreGState() }

                context.translateBy(x: brushStampImage.size.width * -0.5, y: brushStampImage.size.height * -0.5)
                brushStampImage.draw(at: point)
            }
        }
    }

    public func add(_ redaction: Redaction) {
        self.redactions.append(redaction)
        setNeedsDisplay()
    }

    public func add(_ redactions: [Redaction]) {
        self.redactions.append(contentsOf: redactions)
        setNeedsDisplay()
    }

    public func removeAllRedactions() {
        self.redactions = []
    }

    private func registerUndo(with existingRedactions: [Redaction]) {
        guard isUserInteractionEnabled == true else { return }

        undoManager?.registerUndo(withTarget: self, handler: { redactionView in
            redactionView.redactions = existingRedactions
            redactionView.setNeedsDisplay()
        })
    }

    private func brushStamp(scaledToHeight height: CGFloat) -> UIImage {
        guard let standardImage = UIImage(named: "Brush") else { fatalError("Unable to load brush stamp image") }

        let brushScale = height / standardImage.size.height
        let scaledBrushSize = standardImage.size * brushScale

        UIGraphicsBeginImageContext(scaledBrushSize)
        defer { UIGraphicsEndImageContext() }

        guard let context = UIGraphicsGetCurrentContext() else { fatalError("Unable to create brush scaling image context") }
        context.scaleBy(x: brushScale, y: brushScale)

        standardImage.draw(at: .zero)

        guard let scaledImage = UIGraphicsGetImageFromCurrentImageContext() else { fatalError("Unable to get scaled brush image from context") }
        return scaledImage
    }

    // MARK: Notifications

    public static let redactionsDidChange = Notification.Name("PhotoEditingRedactionView.redactionsDidChange")

    // MARK: Boilerplate

    private(set) var redactions = [Redaction]() {
        didSet(existingRedactions) {
            registerUndo(with: existingRedactions)
            NotificationCenter.default.post(name: PhotoEditingRedactionView.redactionsDidChange, object: self)
        }
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
