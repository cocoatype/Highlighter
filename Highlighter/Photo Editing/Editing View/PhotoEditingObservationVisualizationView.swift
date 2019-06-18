//  Created by Geoff Pado on 4/27/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import SpriteKit
import UIKit

class PhotoEditingObservationVisualizationView: SKView {
    init() {
        super.init(frame: .zero)

        backgroundColor = .clear
        isOpaque = false
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false

        reduceMotionObserver = NotificationCenter.default.addObserver(forName: UIAccessibility.reduceMotionStatusDidChangeNotification, object: nil, queue: .main) { [weak self] _ in
            self?.refreshEmitterNode()
        }
    }

    var shouldShowVisualization = true {
        didSet {
            refreshEmitterNode()
        }
    }

    var zoomScale = CGFloat(1) {
        didSet {
            scaleTextObservationLayers()
        }
    }

    var contentOffset = CGPoint.zero {
        didSet {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            textObservationsLayer?.sublayerTransform = CATransform3DMakeTranslation(-contentOffset.x, -contentOffset.y, 0)
            CATransaction.commit()
        }
    }

    // MARK: View Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        let viewSize = bounds.size
        particleEmitterScene.size = viewSize
        emitterNode?.particlePositionRange = CGVector(dx: viewSize.width, dy: viewSize.height)
        emitterNode?.position = CGPoint(x: bounds.midX, y: bounds.midY)

        if scene != particleEmitterScene {
            presentScene(particleEmitterScene)
        }
    }

    // MARK: Scene

    private static let particleName = "Magic"

    private lazy var particleEmitterScene: SKScene = {
        let scene = SKScene(size: .zero)
        scene.backgroundColor = .clear
        guard let emitterNode = SKEmitterNode(fileNamed: PhotoEditingObservationVisualizationView.particleName) else { fatalError("Could not load particle emitter") }
        emitterNode.particleBirthRate = 0
        scene.addChild(emitterNode)
        return scene
    }()

    private var emitterNode: SKEmitterNode? {
        return (particleEmitterScene.children.first(where: { $0 is SKEmitterNode }) as? SKEmitterNode)
    }

    private func refreshEmitterNode() {
        let reduceMotionIsOff = UIAccessibility.isReduceMotionEnabled == false
        let hasTextObservations = textObservations?.isEmpty == false
        let shouldEmitParticles = shouldShowVisualization && hasTextObservations && reduceMotionIsOff
        emitterNode?.particleBirthRate = shouldEmitParticles ? 400 : 0
    }

    // MARK: Text Observations

    var textObservations: [TextObservation]? {
        didSet {
            setNeedsDisplay()
            resetTextObservationLayers()
            refreshEmitterNode()
        }
    }

    private func resetTextObservationLayers() {
        textObservationsLayer?.removeFromSuperlayer()

        let newTextObservationsLayer = CALayer()
        newTextObservationsLayer.frame = layer.bounds
        newTextObservationsLayer.sublayerTransform = CATransform3DMakeTranslation(-contentOffset.x, -contentOffset.y, 0)
        layer.addSublayer(newTextObservationsLayer)
        textObservationsLayer = newTextObservationsLayer

        textObservations?.forEach { observation in
            let sublayer = TextObservationVisualizationLayer(textObservation: observation)
            sublayer.zoomScale = zoomScale
            newTextObservationsLayer.addSublayer(sublayer)
        }
    }

    func scaleTextObservationLayers() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        textObservationsLayer?
          .sublayers?
          .compactMap { $0 as? TextObservationVisualizationLayer }
          .forEach { $0.zoomScale = self.zoomScale }
        CATransaction.commit()
    }

    // MARK: Boilerplate

    private var reduceMotionObserver: Any?

    private var textObservationsLayer: CALayer? {
        didSet {
            layer.mask = textObservationsLayer
        }
    }

    deinit {
        reduceMotionObserver.map(NotificationCenter.default.removeObserver)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

class TextObservationVisualizationLayer: CAShapeLayer {
    init(textObservation: TextObservation) {
        self.textObservation = textObservation
        super.init()

        anchorPoint = .zero
        frame = textObservation.bounds * zoomScale
        let pathRect = bounds.insetBy(dx: 3, dy: 3)
        path = UIBezierPath(roundedRect: pathRect, cornerRadius: 3.0).cgPath
        fillColor = UIColor.black.cgColor
        shadowOpacity = 1.0
        shadowOffset = .zero
    }

    override init(layer: Any) {
        guard let otherLayer = layer as? TextObservationVisualizationLayer else { fatalError("Tried to create a copy of a different layer type: \(type(of: layer))") }
        self.textObservation = otherLayer.textObservation
        super.init(layer: layer)
    }

    var zoomScale = CGFloat(1.0) {
        didSet {
            frame = textObservation.bounds * zoomScale
            path = UIBezierPath(rect: bounds).cgPath
        }
    }

    // MARK: Boilerplate

    private let textObservation: TextObservation

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
