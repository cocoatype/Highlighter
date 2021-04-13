//  Created by Geoff Pado on 4/17/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import ClippingBezier
import UIKit

class PhotoEditingWorkspaceView: UIControl {
    init() {
        imageView = PhotoEditingImageView()
        visualizationView = PhotoEditingObservationVisualizationView()
        redactionView = PhotoEditingRedactionView()
        brushStrokeView = PhotoEditingCanvasBrushStrokeView()

        super.init(frame: .zero)
        isAccessibilityElement = false
        backgroundColor = .appBackground
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)
        addSubview(visualizationView)
        addSubview(redactionView)
        addSubview(brushStrokeView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor),
            visualizationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            visualizationView.centerYAnchor.constraint(equalTo: centerYAnchor),
            visualizationView.widthAnchor.constraint(equalTo: widthAnchor),
            visualizationView.heightAnchor.constraint(equalTo: heightAnchor),
            redactionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            redactionView.centerYAnchor.constraint(equalTo: centerYAnchor),
            redactionView.widthAnchor.constraint(equalTo: widthAnchor),
            redactionView.heightAnchor.constraint(equalTo: heightAnchor),
            brushStrokeView.centerXAnchor.constraint(equalTo: centerXAnchor),
            brushStrokeView.centerYAnchor.constraint(equalTo: centerYAnchor),
            brushStrokeView.widthAnchor.constraint(equalTo: widthAnchor),
            brushStrokeView.heightAnchor.constraint(equalTo: heightAnchor)
        ])

        brushStrokeView.addTarget(self, action: #selector(handleStrokeCompletion), for: .touchUpInside)
    }

    var highlighterTool = HighlighterTool.magic {
        didSet {
            visualizationView.shouldShowVisualization = (highlighterTool == .magic)
        }
    }

    var color: UIColor = .black {
        didSet {
            brushStrokeView.color = color
        }
    }

    var image: UIImage? {
        get { return imageView.image }
        set(newImage) {
            imageView.image = newImage
        }
    }

    var redactions: [Redaction] {
        return redactionView.redactions
    }

    func add(_ redactions: [Redaction]) {
        redactionView.add(redactions)
    }

    func redact<ObservationType: TextObservation>(_ textObservation: ObservationType) {
        redactionView.add(Redaction(textObservation, color: color))
    }

    var textObservations: [TextRectangleObservation]? {
        get { return visualizationView.textObservations }
        set(newTextObservations) {
            visualizationView.textObservations = newTextObservations
        }
    }

    func scrollViewDidZoom(to zoomScale: CGFloat) {
        brushStrokeView.updateTool(currentZoomScale: zoomScale)
    }

    // MARK: Actions

    @objc func handleStrokeCompletion() {
        switch highlighterTool {
        case .magic: handleMagicStrokeCompletion()
        case .manual: handleManualStrokeCompletion()
        case .eraser: handleEraserCompletion()
        }

        sendAction(#selector(BasePhotoEditingViewController.markHasMadeEdits), to: nil, for: nil)
    }

    private func handleMagicStrokeCompletion() {
        guard let strokePath = brushStrokeView.currentPath, let textObservations = textObservations else { return }
        let strokeBorderPath = strokePath.strokeBorderPath
        let redactedCharacterObservations = textObservations
            .compactMap { $0.characterObservations }
            .flatMap { $0 }
            .filter { strokeBorderPath.contains($0.bounds.center) }

        if let newRedaction = Redaction(redactedCharacterObservations, color: color) {
            redactionView.add(newRedaction)
        }
    }

    private func handleManualStrokeCompletion() {
        guard let strokePath = brushStrokeView.currentPath else { return }
        redactionView.add(Redaction(path: strokePath, color: color))
    }

    private func handleEraserCompletion() {
        guard let strokePath = brushStrokeView.currentPath else { return }
        let strokeBorderPath = strokePath.strokeBorderPath
        let intersectedRedactions = redactions.filter { redaction in
            redaction.paths.contains(where: { path in
                path.strokeBorderPath.intersection(with: strokeBorderPath)?.count ?? 0 > 0
            })
        }

        redactionView.remove(intersectedRedactions)
    }

    // MARK: Accessibility

    override func accessibilityActivate() -> Bool {
        print("activate")
        return true
    }

    // MARK: Boilerplate


    private let imageView: PhotoEditingImageView
    private let visualizationView: PhotoEditingObservationVisualizationView
    private let redactionView: PhotoEditingRedactionView
    private let brushStrokeView: UIControl & PhotoEditingBrushStrokeView

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
