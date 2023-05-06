//  Created by Geoff Pado on 5/6/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import ErrorHandling
import UIKit

public class PhotoEditingRedactionView: UIView {
    public init() {
        super.init(frame: .zero)

        accessibilityIgnoresInvertColors = true
        backgroundColor = .clear
        contentMode = .redraw
        isOpaque = false
        translatesAutoresizingMaskIntoConstraints = false

        layer.masksToBounds = true
    }

    public func add(_ redaction: Redaction) {
        self.redactions.append(redaction)
        updateDisplay()
    }

    public func add(_ redactions: [Redaction]) {
        self.redactions.append(contentsOf: redactions)
        updateDisplay()
    }

    public func remove(_ redactions: [Redaction]) {
        self.removeRedactions(where: { redactions.contains($0)})
    }

    public func removeRedactions(where predicate: (Redaction) -> Bool) {
        self.redactions.removeAll(where: predicate)
        updateDisplay()
    }

    public func removeAllRedactions() {
        self.redactions = []
    }

    private func registerUndo(with existingRedactions: [Redaction]) {
        guard isUserInteractionEnabled == true else { return }

        undoManager?.registerUndo(withTarget: self, handler: { redactionView in
            redactionView.redactions = existingRedactions
            redactionView.updateDisplay()
        })
    }

    private func updateDisplay() {
        do {
            layer.sublayers = try redactions.flatMap { redaction -> [RedactionPathLayer] in
                return try redaction.parts
                    .map { try RedactionPathLayer(part: $0, color: redaction.color, scale: layer.contentsScale)}
            }
        } catch {
            ErrorHandler().log(error)
            layer.sublayers = nil
        }
    }

    // MARK: Notifications

    public static let redactionsDidChange = Notification.Name("PhotoEditingRedactionView.redactionsDidChange")

    // MARK: Boilerplate

    private(set) var redactions = [Redaction]() {
        didSet(existingRedactions) {
            guard existingRedactions.count != redactions.count else { return }

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
