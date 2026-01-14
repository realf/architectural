//
//  ShapeLayerRenderer.swift
//  VectorEd
//
//  Created by alf on 14.01.2026.
//

import UIKit

/// Utility for rendering shapes to CAShapeLayer
class ShapeLayerRenderer {
    func updateLayer(_ layer: CAShapeLayer, for shape: any Shape) {
        layer.path = shape.path().cgPath

        switch shape.style.mode {
        case .fill:
            layer.fillColor = shape.style.fillColor?.uiColor.cgColor
            layer.strokeColor = nil
        case .stroke:
            layer.fillColor = nil
            layer.strokeColor = shape.style.strokeColor.uiColor.cgColor
            layer.lineWidth = shape.style.lineWidth
        case .both:
            layer.fillColor = shape.style.fillColor?.uiColor.cgColor
            layer.strokeColor = shape.style.strokeColor.uiColor.cgColor
            layer.lineWidth = shape.style.lineWidth
        }

        layer.lineCap = .round
        layer.lineJoin = .round
    }
}
