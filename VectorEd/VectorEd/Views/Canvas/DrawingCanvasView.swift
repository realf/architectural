//
//  DrawingCanvasView.swift
//  VectorEd
//
//  Created by alf on 14.01.2026.
//

import UIKit

/// View that renders the drawing canvas
class DrawingCanvasView: UIView {
    private var document: DrawingDocument?
    private var state: DrawingState?
    private let renderer = ShapeLayerRenderer()

    // Layer management
    private var shapeLayers: [UUID: CAShapeLayer] = [:]
    private var temporaryLayer: CAShapeLayer?


    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .white
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemGray4.cgColor
    }

    // MARK: - Rendering

    /// Render the complete document
    func render(document: DrawingDocument) {
        self.document = document

        // Remove layers for deleted shapes
        let shapeIDs = Set(document.shapes.map { $0.shape.id })
        let layerIDs = Set(shapeLayers.keys)
        let deletedIDs = layerIDs.subtracting(shapeIDs)

        for id in deletedIDs {
            shapeLayers[id]?.removeFromSuperlayer()
            shapeLayers.removeValue(forKey: id)
        }

        // Update or create layers for shapes
        for anyShape in document.shapes {
            let shape = anyShape.shape

            if let existingLayer = shapeLayers[shape.id] {
                // Update existing layer
                renderer.updateLayer(existingLayer, for: shape)
            } else {
                // Create new layer
                let newLayer = shape.createLayer()
                layer.addSublayer(newLayer)
                shapeLayers[shape.id] = newLayer
            }
        }
    }

    /// Update state-dependent visuals
    func updateState(_ state: DrawingState) {
        self.state = state

        // Update temporary shape being drawn
        if let tempShape = state.temporaryShape {
            if temporaryLayer == nil {
                let temp = tempShape.createLayer()
                temp.opacity = 0.5
                temporaryLayer = temp
                layer.addSublayer(temp)
            }
            renderer.updateLayer(temporaryLayer!, for: tempShape)
        } else {
            temporaryLayer?.removeFromSuperlayer()
            temporaryLayer = nil
        }
    }
}
